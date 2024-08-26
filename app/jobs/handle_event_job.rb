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
    puts "🟣🟣🟣🟣🟣🟣🟣🟣🟣#{stripe_event.type}🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"

    case stripe_event.type
    when 'customer.created'
      handle_customer_created(stripe_event)
    end
  end

  def handle_customer_created(stripe_event)
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
    puts "customer created #{stripe_event.data.object.id}"
    puts '🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢'
  end
end
