class ChargesController < ApplicationController
  def new
    @amount = 510
  end
  
  def create
    @amount = 510
  
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
  
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path, amount: @amount
  end
end
