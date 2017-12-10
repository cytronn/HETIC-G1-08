class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_tags

  def index
    if params[:tag]
      @dishes = Dish.tagged_with(params[:tag])
    else
      @dishes = Dish.all
    end
  end
  
  def show
    @userId = current_user.id
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
    params.require(:dish).permit(:name, :description, :ingredients, :portions, :delivery_at, :cover, :tag_slugs => [])
  end
  
  protected
  def get_tags
      @tags = Tag.all
    end
end
