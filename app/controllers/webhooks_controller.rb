class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  # this controller will be used to receive 'post' requests from 3rd parties (stripe, or else).
  # think of it as a spaceport to dock all foreign ships that want to bring stuff to the app and handle them from here.

  def create
    event = Event.create(
      data: params,
      source: params[:source]
    )
    HandleEventJob.perform_later(event)
    render json: { status: :ok }
  end
end
