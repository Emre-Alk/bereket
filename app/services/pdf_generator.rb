require 'open-uri'

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
    # puts "Template PDF pages: #{template_pdf.pages.count}"
    # puts "Dynamic PDF pages: #{dynamic_pdf.pages.count}"
    # puts "#{@data}"

    # Step 4: Overlay dynamic PDF onto template PDF

    template_pdf.pages.each_with_index do |page, index|
      page_stamp = dynamic_pdf.pages[index]
      page << page_stamp if page_stamp
    end



    # Step 5: return the combined PDF
    template_pdf.to_pdf # string data to pdf
  end

  private

  def generate_dynamic_pdf
    # how to locate placeholder on template and convert it here for dynamic to match template
    # template:
    # origin top left corner
    # x to left
    # y towards bottom. total distance 842 pts
    # dynamic prawn pdf:
    # origin bottom left corner
    # x to left (same as template) but shilfted towards left by 36 pts. total distance to paper edge 528 pts
    # y towards top (inverted compare to template) + shifted towards top by 38 pts. total distance to paper edge 804pts
    # how to - steps in order:
    # 1 => measure on template the coordinates (left and top) (ie, x and y of template)
    # 2 get x for dynamic => x(d) = x(t) - 36
    # 3 get y for dynamic => y(d) = 804 - y(t) + 9 (9 is the height of the police)
    # 4 => finally make adjustments

    # Prawn to generate (library method) a pdf that will be used as a 'calque'
    Prawn::Document.generate("temporary.pdf") do |pdf|
      # for each data entry, the coordinates of the corresponding placeholder to be filled is passed.
      pdf.text_box @data[:receipt], at: [403, 692]
      pdf.text_box @data[:asso][:identity][:name], at: [130, 645]
      pdf.text_box @data[:asso][:identity][:nra], at: [159, 625]
      pdf.text_box @data[:asso][:place][:street_no], at: [14, 598]
      pdf.text_box @data[:asso][:place][:address], at: [98, 598]
      pdf.text_box @data[:asso][:place][:zip_code], at: [71, 584]
      pdf.text_box @data[:asso][:place][:city], at: [204, 584]
      pdf.text_box @data[:asso][:place][:country], at: [38, 572]
      pdf.text_box @data[:asso][:identity][:object],
        at: [34, 560],
        width: 487,
        height: 30,
        overflow: :shrink_to_fit,
        min_font_size: nil
      # tick some boxes
      pdf.fill_rectangle [-1, 413], 6, 6.2 # table select row
      pdf.fill_circle [31.5, 460.7], 3 # 1st row, 'Association loi 1901'
      # new page
      pdf.start_new_page
      pdf.text_box @data[:donator][:first_name].titleize, at: [37, 565]
      pdf.text_box @data[:donator][:last_name].titleize, at: [323, 565]

      pdf.text_box @data[:donator][:address].titleize, at: [98, 535]
      pdf.text_box @data[:donator][:zip_code], at: [63, 520]
      pdf.text_box @data[:donator][:city].titleize, at: [198, 520]
      pdf.text_box @data[:donator][:country].titleize, at: [50, 505]

      pdf.text_box "*****#{@data[:donation][:amount]}*****", at: [8, 452] # error of text_box when integer/float type
      pdf.text_box "*****#{@data[:donation][:amount_human]} euros*****", at: [322, 452]
      pdf.text_box @data[:donation][:occured_on], at: [150, 432]
      pdf.text_box @data[:today], at: [274, 176]
      # tick some boxes
      pdf.fill_rectangle [64.2, 364], 6, 6.2 # '200 du CGI'
      # pdf.fill_rectangle [-1, 327], 6, 6.2 # 'Acte authentique'
      pdf.fill_rectangle [255, 327], 6, 6.2 # 'don manuel'
      pdf.fill_rectangle [-1, 290], 6, 6.2 # 'Numéraire'

      case @data[:donation][:mode]
      when 'espèce'
        pdf.fill_rectangle [-1, 222], 6, 6.2 # 'Espèce'
      when 'virement, prélèvement, carte bancaire'
        pdf.fill_rectangle [255.2, 222], 6, 6.2 # 'Virement, prélèvement, carte bancaire'
      when 'chèque'
        pdf.fill_rectangle [114.8, 222], 6, 6.2 # 'Chèque'
      end

      # To do: add all data required as well as a 'cachet' and 'scaned signature' of the asso
      signature = @data[:asso][:identity][:signature]
      if signature.attached? # signature is used only if it is attached to the model (ie, it exists)
        # -----------  if store signature service is :local
        # signature_blob = signature.blob
        # signature_path = ActiveStorage::Blob.service.path_for(signature_blob.key)
        # ----------- if store signature service is :cloudinary
        signature_path = Cloudinary::Utils.cloudinary_url(signature.url)
        pdf.image URI.parse(signature_path).open, position: 330, vposition: 525, height: 50
      end
    end
  end
end
