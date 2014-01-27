class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    watches_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) {
     |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name) }
    devise_parameter_sanitizer.for(:sign_up) {
     |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name) }
  end
end
