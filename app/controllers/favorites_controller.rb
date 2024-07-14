class FavoritesController < ApplicationController

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
          render json: {
            message: 'created',
            html_favorite_icon: render_to_string(partial: "favorites/favorite_icon", locals: { place: @place, donator: @donator, favorite: @favorite }, formats: :html)
          }
        else
          render json: { message: 'Unprocessable Entity' }, status: 422
        end
      end
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    if @favorite.destroy
      render json: { message: 'destroyed' }, status: 200
    else
      render json: { message: 'Unprocessable Entity' }, status: 422
    end
  end
end
