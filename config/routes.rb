  Rails.application.routes.draw do

  root "welcome#index"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :tenants, only: [:new, :create]
  resources :categories, only: [:show, :index]
  resources :projects

  get "/choose", to: "static_pages#choose"

  resource :pending_loan, except: [:index, :edit]

  post "/pending_loans", to: "pending_loans#checkout_pending_loans",
                         as: "checkout_pending_loans"

  namespace :admin do
    get "/dashboard", to: "base#dashboard"
    resources :categories
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
