class VisitorOrdersController < ApplicationController
  before_filter :valid_email_or_redirect, :only => :new
  before_filter :create_visitor, only: :create

  def create
    @order = @visitor.orders.new(params[:order])
    @order.update_attribute(:store, current_store)
    @order.tap { |order| order.save }.add_order_items_from(@cart)
    if @order.save_with_payment
     manage_session_and_redirect
    else
     render :new
    end
  end

  def new
    session[:guest_email] = params[:guest_email]
    visitor_user = VisitorUser.new(email: session[:guest_email])
    if visitor_user.save
      make_order
    else
      redirect_to new_store_checkout_path(current_store),
        :alert => "You need a email to checkout as a Guest."
    end
  end

  def show
    @order = Order.where(:unique_url => params[:id]).first
    @address = @order.address
  end

private

  def manage_session_and_redirect
    session["#{current_store.slug}_cart_id"] = nil
    session[:checking_out] = nil
    @cart.destroy
    redirect_to store_visitor_order_path(current_store, @order.unique_url),
          :notice => "Transaction Complete"
  end

  def make_order
    @path = store_visitor_orders_path(current_store)
    if @cart.quantity == 0
      redirect_to current_store,
      :alert => "You can't order something with nothing in your cart."
    else
      @order = Order.new.tap { |order| order.build_address }
    end
  end

  def valid_email_or_redirect
    unless User.where(:email => params[:guest_email]).count == 0
      redirect_to new_session_path, :alert => "Not a unique email"
    end
  end

  def create_visitor
    @visitor = VisitorUser.create(:email => session[:guest_email])
  end
end
