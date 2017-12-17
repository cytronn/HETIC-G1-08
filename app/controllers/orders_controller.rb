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
    @order = Order.new(order_params.merge(status: 'pending').merge(dish_id: @dish.id))
    if @order.quantity <= @dish.portions
      @dish.portions -= @order.quantity
      if @order.save && @dish.save
        redirect_to dish_order_pay_url(@dish, @order)
      else
        @dish.portions += @order.quantity
        render :new
      end
    end
  end
  
  def pay
    @order = Order.find_by!(slug: params[:order_slug])
    if @order.status == Order.statuses[:paid]
      redirect_to @order
    end
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @amount = (@dish.price * @order.quantity * 100).to_i
    if request.post?
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
      @order.update(status: Order.statuses[:paid], charge_id: charge.id, amount: @amount)
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
        .permit(:note, :quantity, :amount, :status, :charge_id)
        .merge(user_id: current_user.id)
    end
end
