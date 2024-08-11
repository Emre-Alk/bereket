class PdfGenerator

  # location where the template is in the filesystem.
  # in lib, users cannot access it via urls. (kindof 'private')
  TEMPLATE_PATH = Rails.root.join('lib', 'templates', 'cerfa.pdf')

  def initialize(data)
    @data = data
  end

  def generate

    # Step 1: Generate a new PDF with dynamic content
    generate_dynamic_pdf

    # Step 2: Load the existing PDF template
    template_pdf = CombinePDF.load(TEMPLATE_PATH)

    # Step 3: Load the newly generated dynamic PDF
    dynamic_pdf = CombinePDF.load("temp.pdf")

    # some checking that objects exist
    puts "Template PDF pages: #{template_pdf.pages.count}"
    puts "Dynamic PDF pages: #{dynamic_pdf.pages.count}"
    puts "#{@data}"

    # Step 4: Overlay dynamic PDF onto template PDF

    template_pdf.pages.each_with_index do |page, index|
      # puts "🔅🔅🔅#{index}🔅🔅🔅"
      # puts "🔅🔅🔅#{dynamic_pdf.pages[index].class}🔅🔅🔅"
      page_stamp = dynamic_pdf.pages[index]
      page << page_stamp if page_stamp
    end

    # Step 5: Save the combined PDF.
    template_pdf.to_pdf


  end

  private

  def generate_dynamic_pdf

    # Prawn to generate (library method) a pdf that will be used as a 'calque'
    Prawn::Document.generate("temp.pdf") do |pdf|
      # for each data entry, the coordinates of the corresponding placeholder to be filled is passed.
      pdf.draw_text "user name: #{@data[:user_name]}", at: [419, 112]
      pdf.draw_text "user mail: #{@data[:user_email]}", at: [0, 0]
      # Add more text or images as needed
      # To do: add all data required as well as a 'cachet' and 'scaned signature' of the asso
    end
  end

end
