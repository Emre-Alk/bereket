class PlacesController < ApplicationController
  def show
    @place = Place.find(params[:id])
    @donator = current_user.donator
  end
end
