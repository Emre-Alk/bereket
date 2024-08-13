class PlacesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @place = Place.find(params[:id])
    @donator = current_user.donator if user_signed_in?
    @favorite = @place.favorites.where(donator: @donator).take
  end
end
