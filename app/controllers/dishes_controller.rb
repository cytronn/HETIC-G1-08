class DishesController < ApplicationController
  def new
    @dish = Dish.new
  end

  def index
    @dishes = Dish.all
  end

  def create
    print(article_params)
    @dish = Dish.new(article_params)
    if @dish.save
      redirect_to @dish
    else
      render 'new'
    end
  end

  def show
    @dish = Dish.find(params[:id])
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def update
    @dish = Dish.find(params[:id])
    print(article_params)
    if @dish.update(article_params)
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
    def article_params
      params.require(:dish).permit(:name, :description, :portions)
    end
end
