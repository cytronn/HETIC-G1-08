class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def pay
    @dish = Dish.find(params[:dish_id])
    @order = Order.find(params[:order_id])
    @amount = 500
    if request.post?
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Yuumm',
        :currency    => 'eur'
      )
    end
  end

  def new
    @dish = Dish.find(params[:dish_id])
    @order = Order.new
  end

  def create
    @dish = Dish.find(params[:dish_id])
    @order = Order.new(order_params)
    if @order.save
      redirect_to dish_order_pay_url(@dish, @order)
    else
      render :new
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.' 
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def order_params
      params
      .require(:order)
      .permit(:note, :quantity)
      .merge(dish_id: params[:dish_id])
      .merge(user_id: current_user.id)
      .merge(status: 'pending')
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path, amount: @amount

end
