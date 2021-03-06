require 'resque/server'

StoreEngine::Application.routes.draw do
  
  root :to => "static#home"

  get "info/home"

  mount Resque::Server.new, :at => "/resque"

  match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code
  match '/unauthorized', :to => "static#unauthorized"
  match '/about', :to => "static#about"

  resources :users, only: [:show, :create, :new, :edit, :update]

  resource :user do
    resources :orders, :only => [:index, :show]
  end

  resources :stores, :only => [:show, :index, :create, :new]

  match '/profile', :to => "stores#index"

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :sessions

  scope ':store_slug', :module => "stores", :as => "store" do
    match '/', :to => 'products#index', :as => ""

    resource  :cart, only: [:show, :update]
    resources :cart_products, only: [:new, :update, :destroy]
    resources :products, only: [:index, :show] do
      resource :categories, only: :show
    end

    resources :categories , only: [:show]
    resources :orders, only: [:new, :create]
    resources :guest_orders, only: [:index, :new, :show, :create]
    resources :credit_cards, only: [:new, :create, :index]
    resources :shipping_details, only: [:new, :create, :index]
    resources :calls, only: [:new, :create, :index]

    namespace :admin do
      #resource :store, only: [:edit, :update]
      resources :products do
        resource :retirement, only: [:create, :update]
      end
      resources :categories
      resources :orders, only: [:index, :show, :update] do
        resource :status, only: :update
      end
      # resources :users, only: [:show, :new, :create, :destroy, :update]
      resources :roles, only: [:new, :create, :destroy]
      resource :store, only: [:edit, :update]
    end
    match '/admin', :to => 'admin/dashboard#show'
    match '/stock/products', :to => 'admin/products#index'
  end

  namespace :admin do
    resources :stores, only: [:index, :update]
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update] do
      resource :status, only: :update
    end
  end

end
