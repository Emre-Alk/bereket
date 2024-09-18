class ReviewsController < ApplicationController
  def create
    respond_to do |format|
      format.html
      format.json do
        render json: { message: 'review received' }
      end
    end
  end
end
