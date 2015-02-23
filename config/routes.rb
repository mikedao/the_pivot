Rails.application.routes.draw do

  root "categories#index"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: "logout"

  resources :tenants, only: [:new, :create, :index]
  resources :categories, only: [:show, :index]
  resources :projects

  get "/choose", to: "static_pages#choose"

  resource :pending_loan, except: [:index, :edit]

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
