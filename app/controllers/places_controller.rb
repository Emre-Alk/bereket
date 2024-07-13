class PlacesController < ApplicationController
  def show
    @place = Place.find(params[:id])
    @donator = current_user.donator
    @favorite = @place.favorites.where(donator: @donator).take
  end
end
