class Assos::AccountsController < AssosController
  # might need to add/remove before action to restrict to asso role user ? (done in asso ctrl)

  def show
    # to display account info to user.
    # the access to it, can be done via a menu item in the navbar.
    # not Index because asso will have only one account to display
    # text = 'Compte incomplet. Vous devez finir la création de votre compte pour commencer à recevoir des paiements.'
    # @account = current_user.asso.account.nil? ? text : current_user.asso.account.stripe_id
    @account = current_user.asso.account
  end

  def account_token
    respond_to do |format|
      format.json do
        # render json: { publishableKey: ENV['STRIPE_PUBLISHABLE_KEY'] }
        render json: { publishableKey: ENV["STRIPE_PUBLIC_KEY_LIVE"] }
      end
    end
  end

  def create
    # this is used to create a stripe connected account to an asso user
    # this action will be hit by a post request from a form submit within a button
    # this button should appear once the user has created 'asso' record
    # it should be in the continuity of the place creation flow like:
    # user created with asso role > add a place to asso > create account to start receive money
    # => maybe after info from API call to RNA is confirmed by user

    @account = Account.find_or_create_by(asso: current_user.asso)

    # create a stripe account service instance:
    # first, to make an API call to create connected account for this asso
    service = StripeAccount.new(@account)

    service.create_account

    # then, to generate an onboarding flow for this connected account (necessary to enable payouts)
    redirect_to service.onboarding_url, allow_other_host: true
  end
end
