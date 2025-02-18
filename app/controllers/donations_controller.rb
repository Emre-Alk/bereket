class DonationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new edit update successful]
  # skip auth (only new), apply auth by redirection inside new
  before_action :redirect_if_asso, only: %i[new edit update successful]
  # before_action :store_user_location!, only: [:new], if: :storable_location?
  after_action :store_user_location!, only: [:successful], if: :storable_location?

  def index
    # user = current_user.donator? ? Donator.find(params[:donator_id]) : Asso.find(params[:asso_id])
    # @donations = user.donations
    if current_user.donator?
      @donator = Donator.find(params[:donator_id])
      @donations = @donator.donations.order(created_at: :desc)
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
      @donations = Donation.includes(place: :asso).where(places: { asso_id: asso.id }).order(created_at: :desc)
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
    if array_all_amounts.length.positive?
      @frequent_amount = array_all_amounts.tally.max_by { |_key, value| value }[0] / 100
      @frequent_amount = @frequent_amount&.ceil ||= 10
    else
      @frequent_amount = 10
    end

    @amount_option.push(@frequent_amount)
    @amount_option.sort!

    respond_to do |format|
      format.html # this means for all HTTP request with 'accept type html' header, just respond with the usual html view.
      format.json do # from scan JS Ajax call to get resource (place)
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

  def edit
    # the donation record is create by asso (assos::donations#create), scanned by visitor (token: secured link) and comes here to edit his personal info
    # finally, donation record is updated with visitor information
    # if donation exists or not managed on the view with if condtion.
    @token = params[:token]
    @donation = Donation.find_by_token_for(:donation_link, @token)
    @donator ||= current_user&.donator
  end

  def update
    # create a find or initialize a new user with info inputs
    # retrieve second time visitor or registered but not logged in user or create first time visitor account
    # save the edited donation

    # retrieve the donation submited
    @donation = Donation.find_by_token_for(:donation_link, params[:token])
    return edit_place_donation_path(params[:place_id], params[:id]) unless @donation

    email = params[:donator][:email]

    # retrieve a donator
    if current_user
      # case 1 - donator exists and logged in
      # not tested
      @donation.donator = current_user.donator
      puts '🟧🟧🟧🟧🟧🟧🟧'
    else
      donator = Donator.find_by(email:)

      if donator
        # case 2 - donator exists (enrolled) but Not logged in
        # case 3 - donator exists as visitor
        @donation.donator = donator
        puts '🟩🟩🟩🟩🟩🟩🟩🟩'
      else
        # case 4 - new visitor (1st visit)
        puts '🟪🟪🟪🟪🟪🟪🟪🟪'

        # for now get all attributes but ultimetly, save Y/N btn:
        # if Y => enrolled and save info
        # if N => visitor and build data hash to send to job
        @donator = Donator.new(
          email:,
          first_name: params[:donator][:first_name],
          last_name: params[:donator][:last_name],
          address: params[:donator][:address],
          city: params[:donator][:city],
          country: params[:donator][:country],
          zip_code: params[:donator][:zip_code],
          status: 'visitor'
        )

        # save the new record
        if @donator.save
          # update the donation with donator_id
          @donation.donator = @donator
        else
          return render 'edit', assigns: { token: params[:token] }, status: 422 # this renders edit but without the token anymore which will cause donation not to be found again
        end
      end
    end

    # redirect to same view as checkout#show to be consistent (using partial with locals)
    if @donation.save!
      redirect_to success_place_donation_path(params[:place_id], params[:id]), notice: "Votre reçu fiscal vous a été envoyé à l'adresse mail #{email}"
    else
      puts '💬💬💬💬💬💬'
      render 'edit', status: 422
    end
  end

  def successful
    @donation = Donation.includes(:donator, place: [:favorites]).find(params[:id])
    @favorite = @donation.place.favorites.where(donator: @donation.donator).take
    detaxed_rate = 0.66 # logic auto selon type asso à implementer
    @reduction = @donation.amount * detaxed_rate
    @after_reduction = @donation.amount - @reduction
  end

  private

  def set_donator_params
    params.require(:donator).permit(:first_name, :last_name, :email, :adress, :zip_code, :country, :city)
  end

  def redirect_if_asso
    if user_signed_in? && current_user.asso?
      # a shared/flashes created and rendered in application.html.erb but need some timeout to close it after a delay
      flash[:alert] = "Désolé, vous ne pouvez pas faire de don en tant qu'association."
      redirect_to asso_root_path
    end
  end

  def storable_location?
    request.get? == false && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:resource, request.fullpath)
  end
end
