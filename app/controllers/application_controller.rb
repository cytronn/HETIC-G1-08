class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Uncomment the next if you want to make the homepage accessible to only registered users
  # before_action :authenticate_user!
end
