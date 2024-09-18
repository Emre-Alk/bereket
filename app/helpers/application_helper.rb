module ApplicationHelper
  def qr_generate(url)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end

  def svg_tag(path, options = {})
    svg_content = File.open("app/assets/images/#{path.split(" ").join("_").downcase}.svg", "rb") do |file|
      raw file.read
    end

    if options[:class].present?
      svg_content.sub!(/<svg(.*?)>/, "<svg\\1 class='#{options[:class]}'>")
    end

    if options[:data].present?
      options[:data].each do |key, value|
        key = key.to_s.split("_").join("-")
        svg_content.sub!(/<svg(.*?)>/, "<svg\\1 data-#{key}=#{value}>")
      end
    end

    raw svg_content
  end
end
