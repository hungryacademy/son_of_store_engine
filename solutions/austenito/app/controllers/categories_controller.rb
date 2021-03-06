class CategoriesController < ApplicationController
  before_filter :user_may_manage, only: [:new, :create, :update, :edit, :index]
  before_filter :store_required

  def show
    @category = current_store.categories.find_by_id(params[:id])
    if @category
      @products = @category.products.page(params[:page]).per(24)
    else
      return redirect_to store_products_path(current_store),
             alert: "This store does not have that category."
    end
  end

  def new
    @category = current_store.categories.new
  end

  def create
    @category = current_store.categories.new(params[:category])
    if @category.save
      redirect_to store_categories_path(current_store),
      notice: "Categories all the way down!"
    else
      render 'new'
    end
  end

  def edit
    @category = current_store.categories.find(params[:id])
  end

  def update
    @category = current_store.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to store_categories_path(current_store),
      :notice => "Category updated."
    else
      render 'edit'
    end
  end

  def index
    @categories = current_store.categories
  end


  private

end
