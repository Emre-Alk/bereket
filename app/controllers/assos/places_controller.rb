class Assos::PlacesController < AssosController

  def index
    # list all the current asso's places
    @places = current_user.asso.places
  end

  def show
    # show one of the current asso's places
    @place = Place.find(params[:id])

    # qr code start
    @qr_code = RQRCode::QRCode.new(@place.qr_code)
    @qr_code_svg = @qr_code.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      standalone: true
    )
    # tune options to get right size see: https://github.com/whomwah/rqrcode#as-svg
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

    # next change url to right location once donation path are coded
    url = "url to place's donation page"
    @place.qr_code = url
    if @place.save
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
    params.require(:place).permit(:name, :address, :street_no, :city, :country, :place_type_id, :qr_code)
  end
end
