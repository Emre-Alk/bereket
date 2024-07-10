class DonatorsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_donator?

  def dashboard
  end

  def new
    @donator = Donator.new
  end
end
