class QrGenerator
  attr_reader :place
  include Rails.application.routes.url_helpers

  def initialize(place)
    @place = place
  end

  def default_url_options
    Rails.env.production? ? { host: 'https://www.goodify.fr' } : { host: 'localhost:3000' }
  end

  def qr_generate(options = {})
    # create an instance of rqrcode  with 'url'
    url = Rails.env.production? ? new_place_donation_url(place) : "http://192.168.1.168:3000#{new_place_donation_path(place)}"
    qrcode = RQRCode::QRCode.new(url)

    # qrcode.as_svg(
    #   # Padding around the QR Code in pixels (default 0)
    #   offset: options[:offset].presence || 0,
    #   # Background color e.g "ffffff" or :white or :currentColor (default none)
    #   fill: options[:fill].presence || 'none',
    #   # Foreground color e.g "000" or :black or :currentColor (default "000")
    #   color: options[:color].presence || "000",
    #   # The Pixel size of each module (defaults 11)
    #   module_size: options[:module_size].presence || 11,
    #   # SVG Attribute: auto | optimizeSpeed | crispEdges | geometricPrecision (defaults crispEdges)
    #   shape_rendering: options[:shape].presence || "crispEdges",
    #   # Whether to make this a full SVG file, or only an svg to embed in other svg (default true)
    #   standalone: options[:standalone].presence || true,
    #   # Use <path> to render SVG rather than <rect> to significantly reduce size. (default true)
    #   use_path: options[:standalone].presence || true,
    #   # Replace the `svg.width` and `svg.height` attribute with `svg.viewBox` to allow CSS scaling (default false)
    #   viewbox: options[:viewbox].presence || false,
    #   # A optional hash of custom <svg> attributes. Existing attributes will remain. (default {})
    #   svg_attributes: options[:svg_attributes].presence || {}
    # )

    # generate svg via rqrcode supported attributes
    svg = qrcode.as_svg(
      color: :currentColor,
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      viewbox: true
    )

    # Add CSS class to the <svg> element
    if options[:class].present?
      svg = svg.sub('<svg', "<svg class=\"#{options[:class]}\"")
    end

    # To render raw SVG in views
    svg = svg.html_safe
  end

  # def upload_cloud(svg)
  #   upload_url = Cloudinary::Uploader.upload(
  #     StringIO.new(svg),
  #     public_id: "qr_code_#{place.id}",
  #     resource_type: :image,
  #     format: 'png',
  #     quality: 'auto',
  #     folder: "#{Rails.env}/asso/#{place.asso.id}/place/#{place.id}/qrcode",
  #     overwrite: true
  #   )
  # end
end
