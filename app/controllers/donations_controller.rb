class DonationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new edit]
  # skip auth (only new), apply auth by redirection inside new
  before_action :redirect_if_asso, only: %i[new edit]
  # before_action :store_user_location!, only: [:new], if: :storable_location?

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
    @token = params[:token]
    @donation = Donation.find_by_token_for(:donation_link, @token)
    @donator = current_user&.donator
  end

  def update
    # create a find or initialize a new user with info inputs
    # retrieve second time visitor or registered but not logged in user or create first time visitor account
    # save the edited donation

    # retrieve the donation submited
    @donation = Donation.find_by_token_for(:donation_link, token)

    # retrieve a donator
    if current_user&.donator
      # if donator (logged in) => retrieve registered donator (see stripe job)
      donator = current_user.donator
      puts '🟪🟪🟪🟪🟪🟪🟪🟪'

    else
      # find or initialize the visitor by email and role
      visitor = User.find_or_initialize_by(
        email: params[:email],
        role: 'donator'
      )

      if visitor.donator&.visitor?
        # if nth time visitor & register_me false => retrieve same visitor account (see stripe job)
        donator = visitor.donator
        puts '⬜️⬜️⬜️⬜️⬜️⬜️⬜️⬜️'

      elsif visitor.donator&.enrolled?
        # if visitor is registered user but not logged_in => retrieve registered donator (see stripe job)
        donator = visitor.donator
        puts '🟧🟧🟧🟧🟧🟧🟧🟧'
      else
        # if 1st time visitor & register_me is false => create a visitor account (see stripe job)
        visitor.password = '123456'
        visitor.first_name = params[:first_name]
        visitor.last_name = params[:last_name]
        visitor.save!

        donator = visitor.donator
        # update the status to visitor
        donator.visitor!
        puts '🟦🟦🟦🟦🟦🟦🟦🟦'
      end
    end

    # update the donation with donator_id
    @donation.donator = donator

    # redirect to same view as checkout#show to be consistent (using partial with locals), Or
    respond_to do |format|
      format.html
      format.json do
        if @donation.save
          # redirect to cerfa dispo:inline (AJAX)
          render json: { message: 'ok', url: pdf_generate_donator_donation_path(donator, donation).to_s }
        else
          redirect_to root_path, alert: "Le lien invalide ou expiré. Merci de contacter l'association sinon le support Goodify."
        end
      end
    end
  end

  private

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
    store_location_for(:user, request.fullpath)
  end
end
