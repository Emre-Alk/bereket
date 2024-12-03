class StripeCustomerUpdateJob < ApplicationJob
  queue_as :default

  def perform(stripe_id, stripe_payload)
    Stripe::Customer.update(stripe_id, stripe_payload)
  end
end
