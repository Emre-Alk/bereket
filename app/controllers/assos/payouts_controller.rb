class Assos::PayoutsController < AssosController
  before_action :set_account, only: %i[new create]

  def new
    # this is to go to view (form) where user confirms his intent to payout
    @account_balance = StripeAccount.new(@account).account_balance
  end

  def create
    # this is to create a payout from the user stripe account to his external bank account
    # Use of the stripeacount class where a payout method is created to make the API call to stripe
    # then redirect to refresh the page so the available fund is updated
    service = StripeAccount.new(@account)
    service.payout

    redirect_to asso_root_path
  end

  private

  def set_account
    @account = Account.find_by(asso: current_user.asso)
  end
end
