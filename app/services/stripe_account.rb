class StripeAccount
  attr_reader :account # to allow all action method know that account is @account
  include Rails.application.routes.url_helpers # by default, in service, don't have access to url/path helper methods

  # this service is used to encapsulate all the API calls to Stripe to perform any related actions
  # such as connected account creation, checkout creation, customer creation, etc...

  def initialize(account)
    @account = account
  end

  def default_url_options
    Rails.env.production? ? { host: 'https://www.goodify.fr' } : { host: 'localhost:3000' }
  end

  def create_account
    return unless account.stripe_id.nil?

    stripe_account = Stripe::Account.create(
      # create account either by 'controller' or by 'type'. They are mutually exclusive.
      # type: 'custom',
      controller: {
        fees: { payer: 'account' },
        losses: { payments: 'stripe' },
        requirement_collection: 'stripe',
        stripe_dashboard: { type: 'none' }
      },
      country: 'FR',
      email: account.asso.email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      },
      business_type: 'non_profit',
      business_profile: {
        # industry: 'membership_organizations__religious_organizations', # not in here
        name: account.asso.name,
        mcc: '8661', # 'religious_organization'
        # mcc: '8398', # 'charitable_and_social_service_organizations_fundraising'
        support_email: account.asso.email,
        url: Rails.env.production? ? place_url(account.asso.places.first) : "https://www.goodify.fr#{place_path(account.asso.places.first)}",
        product_description: 'activités religieuses, spirituelles ou philosophiques',
        support_address: {
          line1: "#{account.asso.places.first.street_no} #{account.asso.places.first.address}",
          city: account.asso.places.first.city,
          country: 'FR',
          postal_code: '69001' # account.asso.places.first.zip_code => need to be valid type
        }
      },
      company: {
        name: account.asso.name,
        structure: 'incorporated_non_profit',
        address: {
          line1: "#{account.asso.places.first.street_no} #{account.asso.places.first.address}",
          postal_code: '69001', # account.asso.places.first.zip_code => need to be valid type
          city: account.asso.places.first.city,
          country: 'FR' # account.asso.places.first.country => a method to use 2-letters standard (ISO 3166-1 alpha-2).
        }
      },
      settings: {
        payouts: {
          schedule: {
            interval: 'daily'
          },
          # statement_descriptor: "DoGood - #{account.asso.name}"
          statement_descriptor: "DoGood service"
        }
      }
      # default_currency: "eur",
    )

    account.update(stripe_id: stripe_account.id)
  end

  def onboarding_url
    Stripe::AccountLink.create(
      {
        account: account.stripe_id,
        refresh_url: assos_account_url, # url for asso to go if refresh (not path because stripe will use it)
        return_url: assos_account_url, # 'http://192.168.1.168:3000/assos/account', # # url for asso to return to (not path because stripe will use it)
        type: 'account_onboarding',
        collection_options: { # collect is deprecated (obsolète. must use this now)
          fields: 'eventually_due'
          # future_requirements: 'omit' # future_requirements (docs doesn't details if value dependent of onboarding type)
        }
      }
    ).url
  end

  def account_balance
    @account_balance ||= Stripe::Balance.retrieve(stripe_account: account.stripe_id)
  end

  def payout
    amount = account_balance.available.first.amount
    @payout ||= Stripe::Payout.create(
      {
        amount:,
        currency: 'eur'
      },
      stripe_account: account.stripe_id
    )
  end
end
