class DonatorsController < ApplicationController
  # authenticate user is devise callback helper for authentication
  # is donator is my custom callback helper for authorization
  before_action :authenticate_user!
  before_action :is_donator?

  def dashboard
  end

  def new
    redirect_to donators_path
  end

  def create
    @donator = Donator.new
    @donator.first_name = current_user.first_name
    @donator.last_name = current_user.last_name
    @donator.email = current_user.email

    if @donator.save
      render :dashboard
    else
      redirect_to new_registration_path(@donator), status: :unprocessable_entity
    end
  end

  private

  def set_donator_params
    params.require(:donator).permit(:first_name, :last_name, :email, :profile_image)
  end
end
