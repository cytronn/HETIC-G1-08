class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by!(slug: params[:slug])
  end

  def new
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @order = Order.new
  end

  def create
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @order = Order.new(order_params.merge(status: 'pending'))
    if @order.save
      redirect_to dish_order_pay_url(@dish, @order)
    else
      render :new
    end
  end
  
  def pay
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @order = Order.find_by!(slug: params[:order_slug])
    @amount = 500
    if request.post?
      @order.update(status: 'paid')
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => @dish.name,
        :currency    => 'eur'
      )
      redirect_to @order
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.' 
  end

  private
    def set_order
      @order = Order.find_by!(slug: params[:slug])
    end
    def order_params
      params
      .require(:order)
      .permit(:note, :quantity)
      .merge(dish_id: params[:dish_id])
      .merge(user_id: current_user.id)
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path, amount: @amount
end
