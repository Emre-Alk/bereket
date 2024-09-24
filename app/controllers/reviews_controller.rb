class ReviewsController < ApplicationController
  def create
    respond_to do |format|
      format.html
      format.json do
        review = Review.new(review_params)
        raise ActiveRecord::RecordNotSaved unless review.save

        render json: { html: render_to_string(partial: "reviews/thanks", formats: :html) }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :donation_id, :rating)
  end
end
