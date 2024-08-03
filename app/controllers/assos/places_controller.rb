class Assos::PlacesController < AssosController
  def index
    # list all the current asso's places
    @places = current_user.asso.places
  end

  def show
    # show one of the current asso's places
    @place = Place.find(params[:id])

    # qr code start
    # -----------SVG with active storage attach to model instance -> works ---------------
    # -----------to be removed if use Qr code PNG instead + modify view also
    @qr_dwl = @place.qr_image.download
    # qr code finish
  end

  def new
    # form to add a new place to the current asso account
    @place = Place.new
  end

  def create
    # save to the db the place filled from the form
    # associate the current asso id to the new place
    @place = Place.new(set_place_params)
    @place.asso = current_user.asso

    if @place.save
      # next change url to right location once donation path are coded
      if Rails.env.production?
        url = new_place_donation_url(@place) # to be checked if DNS manu mano required
        @place.update!(qr_code: url.to_s)
      else
        url = "http://192.168.1.168:3000#{new_place_donation_path(@place)}"
        @place.update!(qr_code: url)
      end

      # ----------if want Qr code in SVG--------------------
      attach_qr_code_svg(@place, @place.qr_code)
      # ----------if want Qr code in PNG--------------------
      # attach_qr_code_png(@place, @place.qr_code)

      redirect_to assos_place_path(@place)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # later
    # delete one of the place from the current asso's places
  end

  private

  def set_place_params
    params.require(:place).permit(:name, :address, :street_no, :city, :country, :place_type_id, :qr_code, :place_image)
  end

  def attach_qr_code_svg(place, url)
    qrcode = RQRCode::QRCode.new(url)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )

    # tune options to get right size see: https://github.com/whomwah/rqrcode#as-svg

    Tempfile.create(['qr_image', '.svg']) do |file|
      file.write(svg)
      file.rewind
      place.qr_image.attach(
        io: file,
        filename: 'qr_image.svg',
        content_type: 'image/svg+xml'
      )
    end
  end

  def attach_qr_code_png(place, url)
    qrcode = RQRCode::QRCode.new(url)
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    place.qr_image.attach(
      io: StringIO.new(png.to_s),
      filename: "qr_image.png",
      content_type: "image/png"
    )
  end
end
