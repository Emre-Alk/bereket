class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'profile'
  def landing
  end
end
