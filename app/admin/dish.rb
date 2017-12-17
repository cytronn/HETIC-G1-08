ActiveAdmin.register Dish do
  permit_params do
    permitted = [:permitted, :attributes]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  permit_params :name, :description, :portions, :ingredients, :delivery_at, :cover, :slug, :price, :user_id

  before_action :only => [:show, :edit, :update, :delete] do
    @dish = Dish.find_by!(slug: params[:id])
  end
end
