class StripeAccount
  attr_reader :account # to allow all action method know that account is @account
  include Rails.application.routes.url_helpers # by default, in service, don't have access to url/path helper methods

  # this service is used to encapsulate all the API calls to Stripe to perform any related actions
  # such as connected account creation, checkout creation, customer creation, etc...

  def initialize(account)
    @account = account
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def create_account
    return unless account.stripe_id.nil?

    stripe_account = Stripe::Account.create(
      # type: 'custom',
      # create account either by 'controller' or by 'type'. They are mutually exclusive.
      controller: {
        stripe_dashboard: { type: 'none' },
        fees: { payer: 'account' },
        losses: { payments: 'stripe' },
        requirement_collection: 'stripe'
      },
      country: 'FR',
      email: account.asso.email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      },
      business_type: 'non_profit',
      business_profile: {
        industry: 'membership_organizations__religious_organizations',
        mcc: '8661',
        support_email: account.asso.email,
        url: place_url(account.asso.places.first),
        product_description: 'activités religieuses, spirituelles ou philosophiques'
      },
      company: {
        structure: 'incorporated_non_profit'
        # address: {
        #   line1: "#{account.asso.places.first.street_no} #{account.asso.places.first.address}",
        #   city: account.asso.places.first.city,
        #   country: 'FR', # account.asso.places.first.country => a method to use 2-letters standard (ISO 3166-1 alpha-2).
        #   postal_code: '69001' # account.asso.places.first.zip_code => need to be valid type
        # },
        # name: account.asso.name
      }
      # default_currency: "usd",
    )

    account.update(stripe_id: stripe_account.id)
  end

  def onboarding_url
    Stripe::AccountLink.create(
      {
        account: account.stripe_id,
        refresh_url: asso_root_url, # url for asso to go if refresh (not path because stripe will use it)
        return_url: asso_root_url, # url for asso to return to (not path because stripe will use it)
        type: 'account_onboarding',
        collection_options: { # collect is deprecated (obsolète. must use this now)
          fields: 'eventually_due'
          # future_requirements: 'omit' # future_requirements (docs doesn't details if value dependent of onboarding type)
        }
      }
    ).url
  end

  def ensure_external_account
    return if !account.external_bank_account_id.nil?
    # send user to the onboarding again to collect external bank account details by stripe
    # surely need to pass the stripe account id that is concerned
  end
end
