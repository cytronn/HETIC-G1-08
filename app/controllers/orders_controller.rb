class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_non_cooker, only: [:new, :create, :pay]
  before_action :set_order, only: [:show, :edit, :update, :pay, :accept, :reject, :destroy]

  def index
    @orders = Order.all.by_user(current_user.id)
  end

  def show
  end

  def new
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @order = Order.new
  end

  def create
    @dish = Dish.find_by!(slug: params[:dish_slug])
    @order = Order.new(order_params.merge(status: 'pending').merge(dish_id: @dish.id).merge(amount: @dish.price * BigDecimal(order_params[:quantity])))
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
    @currency = 'eur'
    if @order.status == Order.statuses[:paid]
      redirect_to @order
    end
    @dish = Dish.find_by!(slug: params[:dish_slug])
    if request.post?
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => (@order.amount * 100).to_i,
        :description => @dish.name,
        :currency    => @currency
      )
      @order.update(status: Order.statuses[:paid], charge_id: charge.id)
      redirect_to @order, notice: 'Order was successfully created.' 
    end
  end

  def accept
    @order.status = Order.statuses[:accepted]
    if @order.save
      redirect_to @order.dish, notice: 'Order was successfully accepted.' 
    end
  end
  
  def reject
    if @order.charge_id
      Stripe::Refund.create(charge: @order.charge_id)
    end
    @order.status = Order.statuses[:rejected]
    if @order.save
      redirect_to @order.dish, notice: 'Order was successfully rejected.' 
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.' 
  end

  private
    def authenticate_non_cooker
      if (params[:dish_slug])
        dish = Dish.find_by!(slug: params[:dish_slug])
        if dish.user.id == current_user.id
          redirect_to dishes_url
        end
      end
    end
    def set_order
      @order = Order.by_user(current_user.id)
      if params[:order_slug]
        @order = @order.find_by!(slug: params[:order_slug]) 
      else params[:slug]
        @order = @order.find_by!(slug: params[:slug])
      end
    end
    def order_params
      params
        .require(:order)
        .permit(:note, :quantity, :amount, :status, :charge_id)
        .merge(user_id: current_user.id)
    end
end
