class CustomDevise::RegistrationsController < Devise::RegistrationsController
  def new
    @organizations = Organization.all
    @select_organizations = Organization.all_ids_names
    @organization = Organization.new
    @user = User.new 
  end

end 