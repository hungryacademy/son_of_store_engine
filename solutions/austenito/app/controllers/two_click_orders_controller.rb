class TwoClickOrdersController < ApplicationController
  before_filter :authorize

  def create
    if current_user.addresses.first && current_user.stripe_id
      @order = current_store.orders.create(user: current_user)
      @order.two_click(params[:product_id])
      if @order.save_with_payment
        redirect_to store_order_path(@order.store, @order.id),
        :notice => "Transaction Successful" and return
      end
    end
    load_and_redirect
  end

  def load_and_redirect
    @cart.add_or_increment_by_product(params[:product_id])
    redirect_to store_cart_path(current_store),
    :alert => "You don't have a saved credit card.
              Please make a regular purchase,
              and Instant Purchase will be available next time."
  end

  def show
    redirect_to root_path,
    :alert => "You need to be logged in to instant purchase."
  end
end
