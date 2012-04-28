class UsersController < ApplicationController
  before_filter :is_current_user?, only: [ :show, :edit ]
  include SessionHelpers

  def new
    @user = User.new

    if current_store.nil?
      render 'new_global' and return
    end
  end

  def create
    cart_before_login = current_cart

    @user = User.new(params[:user])
    if @user.save
      auto_login(@user)
      transfer_cart_to_user(cart_before_login, @user)
      link = "<a href=\"#{edit_user_url(@user.id)}\">Update your profile.</a>" 
      redirect_to successful_login_path, :notice => "You have been registered. #{link}".html_safe
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @orders = current_user.recent_orders.desc
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    # TODO: ask Charles about this
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user.id), :notice => "Your profile has been updated"
    else
      render :edit
    end
  end

private
  def is_current_user?
    redirect_to root_path unless User.find_by_id(params[:id]) == current_user
  end
end
