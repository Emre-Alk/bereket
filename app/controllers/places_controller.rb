class PlacesController < ApplicationController
  skip_before_action :authenticate_user!
  layout "profile"

  def show
    # set the local to fr for this action only
    I18n.locale = :fr
    @place = Place.find(params[:id])
    # identify donator if signed_in
    @donator = current_user&.donator
    # find if place is in favorite list of donator
    @favorite = @place.favorites.where(donator: @donator).take
    # retrieve all the review on this place
    # 'includes' will load all donations and from all donators when loading place so that N+1 query is avoided
    @reviews = @place.reviews.includes(donation: :donator)
    # calculate the score based on ratings if there is at least one review else set to 0
    @score = @reviews.presence ? @reviews.sum(&:rating).fdiv(@reviews.length) : 0
  end
end
