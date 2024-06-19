class AssosController < ApplicationController
  before_action :authenticate_user!
  before_action :is_asso?

  def dashboard
  end
end
