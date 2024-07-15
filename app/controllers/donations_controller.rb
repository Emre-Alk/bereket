class DonationsController < ApplicationController
  def index
  end

  def new
    @donation = Donation.new
    @place = Place.find(params[:place_id])
    # create an array of all the amounts donated
    array_all_amounts = current_user.donator.donations&.map(&:amount)
    # array to  hash such as 'key' is amount and 'value' its occurence (tally) { 10: 2, 20: 1, ... }
    # then, filter the [key, value] for which value (ie, occurence) is max
    # finally, extract the corresponding key
    @frequent_amount = array_all_amounts.tally.max_by { |_key, value| value }[0] / 100
    @frequent_amount = @frequent_amount.ceil ||= 10
    @amount_option = [50, 20, 30]
    @amount_option.push(@frequent_amount)
    @amount_option.sort!
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
