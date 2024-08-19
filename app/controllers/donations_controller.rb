class DonationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new]
  # skip auth (only new), apply auth by redirection inside new

  def index
    # user = current_user.donator? ? Donator.find(params[:donator_id]) : Asso.find(params[:asso_id])
    # @donations = user.donations
    if current_user.donator?
      @donator = Donator.find(params[:donator_id])
      @donations = @donator.donations
    elsif current_user.asso?
      asso = Asso.find(params[:asso_id])
      # we need to retrieve all donations for an asso collected via all its places
      # associations: from 'donations table' join to 'place table', then join to 'asso table', then filter asso by id
      # use of includes to prevent N+1 query and preload joined tables
      # Here's why both place and asso are specified:
      # Donation Belongs to Place:
      # The donations table has a place_id Fkey, so you can join the donations table with the places table via this key.
      # Place Belongs to Asso:
      # The places table has an asso_id Fkey, so you can join the places table with the assos table using this key.
      # To Filter by Asso:
      # If you want to filter donations by an attribute in asso (like asso_id),
      # you need to traverse both associations (Donation -> Place -> Asso).
      # That's why you need to include both place and asso in the joins

      # writing .includes(:place, :asso) like that, results in two separate joins (which is a solution):
      # join 'donation' to 'place'
      # join 'donation' to 'asso' (which give error because it requires a direct association)
      @donations = Donation.includes(place: :asso).where(places: { asso_id: asso.id })
    else
      render plain: "role not identified"
    end
  end

  def new
    @donation = Donation.new
    @place = Place.find(params[:place_id])

    # this line is executed instead of everything else following unless condition is true
    return @amount_option = [50, 20, 30, 10].sort! unless user_signed_in?

    # else, these lines are executed instead
    @amount_option = [50, 20, 30]
    @donator = current_user.donator
    # create an array of all the amounts donated
    array_all_amounts = @donator.donations&.map(&:amount)
    # array to  hash such as 'key' is amount and 'value' its occurence (tally) { 10: 2, 20: 1, ... }
    # then, filter the [key, value] for which value (ie, occurence) is max
    # finally, extract the corresponding key
    @frequent_amount = array_all_amounts.tally.max_by { |_key, value| value }[0] / 100
    @frequent_amount = @frequent_amount&.ceil ||= 10
    @amount_option.push(@frequent_amount)
    @amount_option.sort!

    respond_to do |format|
      format.html # this means for all HTTP request with 'accept type html' header, just respond with the usual html view.
      format.json do
        if @place
          # if motivated, put donations>new.html.erb into a partial and send it as json with partial: render_to_string()
          render json: {
            message: 'resource found',
            url: new_place_donation_url(@place)
          }
          # else
          # render json: { message: 'resource does not exists' } # or change by a partial for non existing resource.
          # then modify JS how data is handled
        end
      end
    end
  end

  # def create
  #   @donation = Donation.new(set_params_donation)
  #   @place = Place.find(params[:place_id])
  #   @donator = @current_user.donator
  #   if @donation.save
  #     puts "✅✅✅✅✅✅✅✅✅"
  #     # redirect_to donator_root_path
  #     render json: { html_status: render_to_string(partial: "donations/successful", formats: :html) }
  #   else
  #     puts "❌❌❌❌❌❌❌"
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # private

  # def set_params_donation
  #   params.require(:donation).permit(:amount, :occured_on)
  # end
end
