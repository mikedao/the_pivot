Rails.application.routes.draw do
  root "categories#index"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: "logout"

  resources :tenants, only: [:new, :create, :index]
  resources :categories, only: [:show, :index]
  resources :projects

  get "/about/", to: "static_pages#about", as: "about"

  resource :pending_loan, except: [:index, :edit]
  post :delete_pending_loan, to: "pending_loans#delete_one"
  post :update_loan_amount, to: "pending_loans#update"

  namespace :admin do
    get "/dashboard", to: "base#dashboard"
    resources :categories
    resources :tenants, only: [:index, :edit, :update]
    resources :projects, only: [:index, :edit]
  end

  resources :users do
    resources :orders
  end

  scope ":slug", module: "tenants", as: "tenant" do
    get "/" => "projects#index"
    resources :projects
    get "/dashboard" => "dashboard#show"
  end

  match "/create_order", via: [:get], to: "orders#create"
end
