class CheckoutsController < ApplicationController
  skip_before_action :authenticate_user!
  # before_action :check_session!

  def show
    # collect all needed info on the payment to display a success page
    place = Place.find(params[:place_id])
    @checkout_session = Stripe::Checkout::Session.retrieve(
      {
        id: params[:session_id],
        expand: [:line_items]
      },
      {
        stripe_account: place.asso.account.stripe_id
      }
    )
  end

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

    # ============= checkout by redirection ==============
    place = Place.find(params[:place_id])
    amount = params[:amount].to_f * 100
    checkout_session = Stripe::Checkout::Session.create(
      {
        mode: 'payment',
        success_url: place_checkout_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: new_place_donation_url(place),
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'donation'
            },
            unit_amount: amount.to_i
          },
          quantity: 1
        }],
        metadata: {
          place_id: params[:place_id]
        }
      },
      {
        stripe_account: place.asso.account.stripe_id
      }
    )

    redirect_to checkout_session.url, allow_other_host: true
  end

  def test
    @donator = current_user.donator
    puts 'you are in test'
    respond_to do |format|
      format.html
      format.json do
        render json: { url: checkout_test_path }
      end
    end
  end

  private

  def check_session!
    # this works
    # in JS, can insert a pop up with partial in it to sign in ou sign up
    # then, on form submit => come back here with donation info
    # render json: { html_devise: render_to_string(partial: "shared/simple_auth", formats: :html) } unless user_signed_in?

    # this works too
    render json: { url: new_user_session_path }
  end
end
