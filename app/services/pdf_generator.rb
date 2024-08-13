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
    dynamic_pdf = CombinePDF.load("temporary.pdf")

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
    # margin: [37, 37, 42, 42]
    # x_corr = -30
    # y_corr = 483
    # [383 + 40, 695 - 5]
    # Prawn to generate (library method) a pdf that will be used as a 'calque'
    Prawn::Document.generate("temporary.pdf") do |pdf|
      # for each data entry, the coordinates of the corresponding placeholder to be filled is passed.
      pdf.text_box @data[:receipt], at: [423, 692]
      pdf.text_box @data[:asso][:identity][:name], at: [130, 645]
      pdf.text_box @data[:asso][:identity][:nra], at: [159, 625]
      pdf.text_box @data[:asso][:place][:street_no], at: [14, 598]
      pdf.text_box @data[:asso][:place][:address], at: [98, 598]
      pdf.text_box @data[:asso][:place][:zip_code], at: [71, 584]
      pdf.text_box @data[:asso][:place][:city], at: [204, 584]
      pdf.text_box @data[:asso][:place][:country], at: [38, 572]
      pdf.text_box @data[:asso][:identity][:object], at: [34, 560]
      # tick some boxes
      pdf.fill_rectangle [-1, 413], 6, 6.2 # table select row
      pdf.fill_circle [31.5, 460.7], 3 # 1st row, 'Association loi 1901'
      # new page
      pdf.start_new_page
      pdf.text_box @data[:donator][:first_name], at: [37, 565]
      pdf.text_box @data[:donator][:last_name], at: [323, 565]
      pdf.text_box @data[:donation][:amount].to_s, at: [31, 452] # error of text_box when integer/float type
      pdf.text_box "#{@data[:donation][:amount_human]} euros", at: [322, 452]
      pdf.text_box @data[:donation][:occured_on], at: [150, 432]
      pdf.text_box @data[:today], at: [274, 176]
      # tick some boxes
      pdf.fill_rectangle [64.2, 364], 6, 6.2 # '200 du CGI'
      pdf.fill_rectangle [-1, 327], 6, 6.2 # 'Acte authentique'
      pdf.fill_rectangle [-1, 290], 6, 6.2 # 'Numéraire'
      pdf.fill_rectangle [255.2, 222], 6, 6.2 # 'Virement, prélèvement, carte bancaire'
      # To do: add all data required as well as a 'cachet' and 'scaned signature' of the asso
    end
  end

end
