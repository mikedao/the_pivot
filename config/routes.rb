Rails.application.routes.draw do
  get 'cart_items/create'

  root 'welcome#index'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :categories

  post '/carts', to: 'carts#create', as: 'carts'
  get '/cart', to: 'carts#showcart', as: 'showcart'
  post '/cart', to: 'carts#checkout_cart', as: 'checkout_cart'

  resources :items

  namespace :admin do
    get '/dashboard', to: 'base#dashboard'
    resources :categories
    resources :items
    resources :orders
  end

  resources :users do
    resources :orders
  end

end
