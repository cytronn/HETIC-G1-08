class DishesController < ApplicationController
  
  def index
    if params[:tag]
      @dishes = Dish.tagged_with(params[:tag])
    else
      @dishes = Dish.all
    end
  end
  
  def show
    @dish = Dish.find(params[:id])
  end
  
  def new
    @dish = Dish.new
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def create
    print(dish_params)
    @dish = Dish.new(dish_params)
    if @dish.save
      redirect_to @dish
    else
      render 'new'
    end
  end

  # TODO: Fix update (ingredients & dates)

  def update
    @dish = Dish.find(params[:id])
    print(dish_params)
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
      params.require(:dish).permit(:name, :description, :ingredients, :portions, :delivery_at, :all_tags =>[])
    end

end
