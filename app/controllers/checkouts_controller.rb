class CheckoutsController < ApplicationController
  def create
    # on Gorails, corresponds to paymentcontroller#new. A buy btn redirects to new_payment_path to here
    # on tuto fullstack, corresponds to checkoutscontroller#create. AJAX hit it with POST to url /checkout

    # action is to create a checkout module session
    # sub-action: fill session keys: mode, success url, cancel url, line items
    # sub-action: get the ajax data, define 'line_items' (array of objects) [ {obj1}, {obj2},... ]
    # in 'line_items', each object keys are: customer email, price_data (for full options see https://docs.stripe.com/api/checkout/sessions/object?lang=ruby)

    # if no error, render json session.url (this is the response of the API 'Stripe::Checkout::Session.create()')

    # donator = params[:donator_id]
    # donation = params[:donation]
    # donation_amount = donation[:amount]
    # place = Place.find(donation[:place_id])
  end
end
