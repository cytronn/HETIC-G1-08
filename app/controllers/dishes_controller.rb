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
    if current_user.id != @dish.user_id 
    redirect_to @dish
    end
  end

  def create
    @user = User.find(current_user.id)
    @dish = @user.dishes.create(dish_params)
    if @dish.save
      redirect_to @dish, notice: 'Dish was successfully created.' 
    else
      render 'new'
    end
  end
  
  def update
    @dish = Dish.find_by!(slug: params[:slug])
    if @dish.update(dish_params)
      redirect_to @dish, notice: 'Dish was successfully updated.' 
    else
      render 'edit'
    end
  end
  
  def destroy
    @dish = Dish.find(params[:slug])
    @dish.destroy
    redirect_to dishes_path, notice: 'Dish was successfully deleted.' 
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
