class HandleEventJob < ApplicationJob
  queue_as :default

  def perform(event)
    # Here first filter event by 3rd party source (ie, origin like stripe, etc...),
    # to redirect event to the corresponding handler.
    case event.source
    when 'stripe'
      handle_stripe_event(event)
    end
  end

  def handle_stripe_event(event)
    stripe_event = Stripe::Event.construct_from(event.data)

    case stripe_event.type
    when 'customer.created' # test with stripe CLI
      handle_customer_created(stripe_event)
    when 'account.updated' # capabilities.updated
      handle_account_updated(stripe_event)
    when 'capability.updated'
      handle_capability_updated(stripe_event)
    end
  end

  def handle_capability_updated(stripe_event)
    capability = stripe_event.data.object
    if capability.id == 'transfers' && capability.status == 'active'
      account = Account.find_by(stripe_id: capability.account)
      service = StripeAccount.new(account)
      service.ensure_external_account
    end
  end

  def handle_account_updated(stripe_event)
    stripe_account = stripe_event.data.object
    account = Account.find_by(stripe_id: stripe_account.id)
    account.update!(
      charges_enabled: stripe_account.charges_enabled,
      payouts_enabled: stripe_account.payouts_enabled,
      external_bank_account_id: stripe_account.external_accounts.data.id,
      last_four: stripe_account.external_accounts.data.last4
    )
  end

  def handle_customer_created(stripe_event)
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
    puts "customer created #{stripe_event.data.object.id}"
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
  end
end
