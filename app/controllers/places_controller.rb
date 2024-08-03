class PlacesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @place = Place.find(params[:id])
    @donator = current_user.donator
    @favorite = @place.favorites.where(donator: @donator).take
  end
end
