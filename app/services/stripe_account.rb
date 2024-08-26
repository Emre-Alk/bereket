class StripeAccount
  attr_reader :account # to allow all action method know that account is @account
  include Rails.application.routes.url_helpers # by default, in service, don't have access to url/path helper methods

  # this service is used to encapsulate all the API calls to Stripe to perform any related actions
  # such as connected account creation, checkout creation, customer creation, etc...

  def initialize(account)
    @account = account
  end

  def create_account
    return unless account.stripe_id.nil?

    stripe_account = Stripe::Account.create(
      type: 'custom',
      country: 'FR',
      email: account.asso.email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      }
    )

    account.update(stripe_id: stripe_account.id)
  end

  def onboarding_url
    Stripe::AccountLink.create(
      {
        account: account.stripe_id,
        refresh_url: root_asso_url, # url for asso to go if refresh (not path because stripe will use it)
        return_url: root_asso_url, # url for asso to return to (not path because stripe will use it)
        type: 'account_onboarding',
        collection_option: { # collect is deprecated (obsolète. must use this now)
          fields: 'eventually_due',
          future_requirements: 'omit' # future_requirements (docs doesn't details if value dependent of onboarding type)
        }
      }
    ).url
    raise
  end
end
