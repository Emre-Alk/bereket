class DonationsController < ApplicationController
  def index
  end

  def new
    @donation = Donation.new
    @place = Place.find(params[:place_id])
  end

  def create
    @donation = Donation.new(set_params_donation)
    @place = Place.find(params[:place_id])
    @donator = @current_user.donator
    if @donation.save
      puts "✅✅✅✅✅✅✅✅✅"
      # redirect_to donator_root_path
      render json: { html_status: render_to_string(partial: "donations/successful", formats: :html) }
    else
      puts "❌❌❌❌❌❌❌"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_params_donation
    params.require(:donation).permit(:amount, :occured_on)
  end
end
