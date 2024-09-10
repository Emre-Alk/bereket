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
      # when 'capability.updated' # Useful if goal is to create/check financial account as external account
      # handle_capability_updated(stripe_event)
    when 'checkout.session.completed'
      handle_checkout_session_completed(stripe_event)
    end
  end

  def handle_checkout_session_completed(stripe_event)
    # retrive checkout session
    checkout_session = Stripe::Checkout::Session.retrieve(
      {
        id: stripe_event.data.object.id,
        expand: [:line_items, 'payment_intent.payment_method']
      }
    )

    puts '🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩'
    puts checkout_session
    puts '🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩'

    if checkout_session.payment_status == 'paid' # create a donation record if status is paid
      # retrieve a place_id
      place = Place.find(checkout_session.metadata.place_id)

      # retrive a donator_id
      if checkout_session.customer_creation
        # case visitor not converted yet (cus created but not a user yet)
        email = checkout_session.customer_details.email
        name = checkout_session.customer_details.name || checkout_session.customer_details.email
        visitor = User.create!(
          email:,
          password: '123456',
          first_name: name,
          last_name: 'last name',
          role: 'donator'
        )
        donator = visitor.donator
      else
        # case when donator is already registrate
        donator = Customer.find_by(stripe_id: @customer).donator
      end

      # retrive donated amount
      amount = checkout_session.amount_total
      # create a donation record (donator, place, cs, amount brut, occured_on)
      Donation.create!(
        place:,
        donator:,
        amount:,
        occured_on: Date.today,
        checkout_session_id: checkout_session.id
      )
      # for next time, payment intent with cus id and pm id can be done.
      # however, on testing i had to create pi, then "status": "requires_confirmation".
      # so i confirmed via Stripe::PaymentIntent.confirm(), then "status": "succeeded".
      # the money is transfer and my app is paid.
      # in live mode, do i still need to confirm server-side ?
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
      external_bank_account_id: stripe_account.external_accounts.data.first.id,
      last_four: stripe_account.external_accounts.data.first.last4
    )
  end

  def handle_customer_created(stripe_event)
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
    puts "customer created #{stripe_event.data.object.id}"
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
  end
end
