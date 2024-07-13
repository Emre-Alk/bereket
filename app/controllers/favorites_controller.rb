class FavoritesController < ApplicationController
  def new
    @favorite = Favorite.new
  end

  def create
    @donator = Donator.find(params[:donator_id])

    respond_to do |format|
      format.html
      format.json do
        @place = Place.find(params[:content])
        @favorite = Favorite.new(
          donator: @donator,
          place: @place
        )
        if @favorite.save
          render json: { message: 'created' }, status: 201
        else
          render json: { message: 'Unprocessable Entity' }, status: 422
        end
      end
    end
  end
end
