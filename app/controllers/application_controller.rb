class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :get_user

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :organization_id])
    end
    def get_user
      if user_signed_in?
        @current_user = User.find(current_user.id)
      else
        @current_user = nil
      end
    end
end
