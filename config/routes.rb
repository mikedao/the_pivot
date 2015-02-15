Rails.application.routes.draw do

  root "welcome#index"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :categories, only: [:show, :index]
  resources :projects
#  get "cart_projects/create"

#  post "/carts", to: "carts#create", as: "carts"
#  get "/pending_loan", to: "carts#show", as: "pending_loan"
#  delete "/pending_loan", to: "carts#delete_project", as: "delete_pending_loan"
#  put "/cart", to: "carts#update_project_amount", as: "update_project_amount"

#  resources :pending_loans
  post "/pending_loans", to: "pending_loans#create"
  delete "/pending_loans", to: "pending_loans#destroy"
  get "/pending_loan", to: "pending_loans#show"
  delete "/pending_loan", to: "pending_loans#delete_pending_loan", as: "delete_pending_loan"
  post "/pending_loan", to: "pending_loans#checkout_pending_loans", as: "checkout_pending_loans"

  namespace :admin do
    get "/dashboard", to: "base#dashboard"
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
