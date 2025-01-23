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

    respond_to do |format|
      format.html
      format.json do
        if @donation.save
          token = @donation.generate_token_for(:donation_link)
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

  def destroy
    @donation = Donation.find(params[:id])
    @place = Place.find(params[:place_id])
    if @donation.destroy
      redirect_to new_assos_place_donation_path(@place), notice: "Don supprimé avec succès."
    else
      redirect_to new_assos_place_donation_path(@place), alert: "Erreur. Le don n'a pas pu être supprimé."
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:amount, :mode, :occured_on)
  end
end
