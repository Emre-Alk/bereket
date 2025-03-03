class CheckoutsController < ApplicationController
  skip_before_action :authenticate_user!
  # before_action :check_session!

  def show
    # collect all needed info on the payment to display a success page
    @checkout_session = Stripe::Checkout::Session.retrieve(
      {
        id: params[:session_id],
        expand: [:line_items, 'payment_intent.payment_method']
      }
    )

    # @connected_account = @checkout_session.payment_intent.transfer_data.destination
    # @payment_method = @checkout_session.payment_intent.payment_method.id
    # @payment_status = @checkout_session.payment_status

    @donation = Donation.includes(:donator, place: [:favorites]).find_by(checkout_session_id: @checkout_session.id)
    @donator = @donation.donator
    @favorite = @donation.place.favorites.where(donator: @donator).take

    detaxed_rate = 0.66 # logic auto selon type asso à implementer
    @reduction = @checkout_session.amount_total * detaxed_rate
    @after_reduction = @checkout_session.amount_total - @reduction

    # login user if visitor to allow smooth account update (via JS, login succeeds but requires a reload of page to change state to allow 'put' ajax to work)
    # TODO: find a safer way to login visitor only when he choose to convert (ajax)
    # sign_in(@donator.user) if @donator.visitor?
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
    # retrieve the place of donation to transfer the funds to
    place = Place.find(params[:place_id])
    # retrieve the amount set by the donator and convert it in cents
    amount = (params[:amount].to_f * 100)
    # from the docs pricing, build the stripe fee to recover as in destination charge app pays stripe fees
    stripe_fee = {
      # EU cards
      eu: {
        percent: 1.5,
        fixed: 25
      },
      # International cards
      int: {
        percent: 2.9,
        fixed: 25
      }
    }
    # calculate stripe fee for EU cards (for now)
    # TODO: how to change dynamically with card origin (need to retrieve card origin. how ?)
    stripe_fee_amount = ((amount * stripe_fee[:eu][:percent].fdiv(100)) + stripe_fee[:eu][:fixed])
    # set my cut
    app_fee_percent = 0
    app_fee_amount = amount * app_fee_percent.fdiv(100)
    # calculate total amount to substract from funds to transfer to the connected account
    total_fee_amount = app_fee_amount + stripe_fee_amount
    # calculate the funds to transfer to the connected account
    amount_transfer = amount - total_fee_amount

    if user_signed_in?
      # registered users have a customer stripe id on my plateform
      customer = Customer.find_by(donator: current_user.donator)
    end

    checkout_session = Stripe::Checkout::Session.create(
      {
        mode: 'payment',
        success_url: place_checkout_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: new_place_donation_url(place),
        customer: customer&.stripe_id,
        customer_creation: customer&.stripe_id ? nil : 'always', # method always create cus for the 1st time, then create cus with PM collected. then use Pintend
        # customer_email: user_signed_in? ? current_user.donator.email : nil, # if i decide to create cus via session only
        payment_intent_data: {
          # setup_future_usage: 'off_session', # this would be for charging cus later like no-show fee or pay remaining later (not a true save PM)
          transfer_data: {
            destination: place.asso.account.stripe_id, # with destination, stripe fees are taken on my cut
            amount: amount_transfer.to_i # the CA only see the total after fee (ex 9 if charge was 10)
          }
          # on_behalf_of: place.asso.account.stripe_id # must still have destination key. How useful ??
          # application_fee_amount: app_fee_amount # the CA will have all details: tot amount and app fee
        },
        saved_payment_method_options: { # this will ask user if want to save card details
          payment_method_save: 'enabled'
        },
        # payment_method_data: {
        #   allow_redisplay: 'always'
        # },
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
          place_id: place.id, # required for the handleEvent
          total_fee: total_fee_amount,
          app_fee: app_fee_amount,
          stripe_fee: stripe_fee_amount
        },
        submit_type: 'donate'
      }
      # {
      #   stripe_account: place.asso.account.stripe_id
      # }
    )

    redirect_to checkout_session.url, allow_other_host: true
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
