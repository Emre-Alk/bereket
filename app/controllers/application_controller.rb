class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.donator?
      donator_root_path
    elsif resource.asso?
      asso_root_path
    else
      root_path # Fallback path if the user doesn't have a role or role is not recognized
    end
  end

  def is_asso?
    redirect_to donator_root_path unless current_user.asso?
  end

  def is_donator?
    redirect_to asso_root_path unless current_user.donator?
  end

  protected


  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:role, :email, :username, :password, :password_confirmation)
    end
  end
end
