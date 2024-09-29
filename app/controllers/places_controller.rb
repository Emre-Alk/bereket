class PlacesController < ApplicationController
  skip_before_action :authenticate_user!
  layout "profile"

  def show
    I18n.locale = :fr
    @place = Place.find(params[:id])
    @donator = current_user&.donator
    @favorite = @place.favorites.where(donator: @donator).take
    @reviews = @place.reviews.includes(donation: :donator)
    @score = @reviews.sum(&:rating).fdiv(@reviews.length)
  end
end
