class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tags

  def index
    @dishes = Dish.in_organization(current_organization.id).tagged_with(params[:tags]).delivery_day(params[:date])
  end
  
  def show
    @dish = Dish.find_by!(slug: params[:slug])
  end
  
  def new
    @dish = Dish.new
  end
  
  def edit
    @dish = Dish.find_by!(slug: params[:slug])
  end
  
  def create
    @user = User.find(current_user.id)
    @dish = @user.dishes.create(dish_params)
    if @dish.save
      redirect_to @dish
    else
      render 'new'
    end
  end
  
  def update
    @dish = Dish.find_by!(slug: params[:slug])
    if @dish.update(dish_params)
      redirect_to @dish
    else
      render 'edit'
    end
  end
  
  def destroy
    @dish = Dish.find(params[:slug])
    @dish.destroy
    redirect_to dishes_path
  end
  
  private
  def dish_params
    params.require(:dish).permit(:name, :description, :ingredients, :portions, :delivery_at, :cover, :price, :tag_ids => [])
  end

  protected
  def set_tags
    @tags = Tag.all
  end
end
