class CheckoutsController < ApplicationController
  def create
    donator = params[:donator_id]
    donation = params[:donation]
    donation_amount = donation[:amount]
    place = Place.find(donation[:place_id])
  end
end
