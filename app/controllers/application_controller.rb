class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  # protect_from_forgery with: :exception

  # a devise method to execute after the resource(user) has sign in.
  # here I check whether the user has a role set to donator or asso.
  # then i redirect to their dedicated dashboards through the  rails path helper
  # def after_sign_in_path_for(resource)
  #   if resource.donator?
  #     donator_root_path
  #   elsif resource.asso?
  #     asso_root_path
  #   else
  #     root_path # Fallback path to landing page if the user doesn't have a role or role is not recognized
  #   end
  # end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # method to custom routing after a user has signed in
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || first_time_sign(resource)
  end

  protected

  # here i create callbacks to set authorization on user to access dedicated dashboard according their role
  # defining them in the application controller, render them available in any controller that inherits from this application controller
  # they are called as 'before_action' callback in the asso and donator controllers
  def is_asso?
    redirect_to donator_root_path unless current_user.asso?
  end

  def is_donator?
    redirect_to asso_root_path unless current_user.donator?
  end

  # a callback method that i call as 'before action' in the application controller here.
  # It enables to overwrite the params permitted by devise.
  # in a loop form as here all the params are overwritten.
  # first, need to explicite for which action i need devise to permit (here: sign-up)
  # then, I enumarate all attribute to be allowed to pass in params
  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:role, :email, :first_name, :last_name, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password)
    end
  end

  def first_time_sign(resource)
    if resource.donator?
      donator_root_path
    elsif resource.asso?
      asso_root_path
    else
      root_path # Fallback path to landing page if the user doesn't have a role or role is not recognized
    end
  end
end
