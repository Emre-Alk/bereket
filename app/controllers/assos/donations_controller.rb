class Assos::DonationsController < AssosController
  def new
    @donation = Donation.new
    @place = Place.find(params[:place_id])
  end

  def create
    @place = Place.find(params[:place_id])
    @donation = Donation.new(donation_params)
    @donation.place = @place
    @donation.amount_net = @donation.amount
    token = @donation.generate_token_for(:donation_link)

    respond_to do |format|
      format.html
      format.json do
        if @donation.save
          render json: {
            message: 'successful',
            token:,
            html_donation_qrcode: render_to_string(
              partial: 'assos/donations/donation',
              locals: { donation: @donation, place: @place, token: },
              formats: :html
            )
          }
        else
          render json: { message: "Le don n'a pas pu être enregistrer. Merci de réessayer." }, status: 422
        end
      end
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:amount, :mode, :occured_on)
  end
end
