class DishesController < ApplicationController
  before_action :authenticate_user!

  def index
    user = User.find(current_user.id)
    if params[:tag]
      @dishes = Dish.tagged_with(params[:tag])
    else
      @dishes = Dish.in_organization(user.organization_id)
    end
  end
  
  def show
    @dish = Dish.find(params[:id])
  end
  
  def new
    @dish = Dish.new
    @tags = Tag.all
  end

  def edit
    @dish = Dish.find(params[:id])
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
    @dish = Dish.find(params[:id])

    if @dish.update(dish_params)
      redirect_to @dish
    else
      render 'edit'
    end
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy

    redirect_to dishes_path
  end

  private
    def dish_params
      params.require(:dish).permit(:name, :description, :ingredients, :portions, :delivery_at, :cover, :tag_ids => [])
    end

end
