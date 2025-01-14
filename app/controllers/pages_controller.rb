class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landing', only: %i[landing]
  def landing
  end

  def members # créer un controller membre sous namespace asso
    @place = Place.includes(donations: :donator).find(params[:place])
  end

  def tools # créer un controller outils sous namespace asso pour CRUD tools ?
    @place = Place.find(params[:place])
  end

  def cerfa

  end
end
