Rails.application.routes.draw do
  get 'cart_items/create'

  root 'welcome#index'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :categories

  post '/carts', to: 'carts#create', as: 'carts'
  get '/cart', to: 'carts#showcart', as: 'showcart'
  post '/cart', to: 'carts#checkout_cart', as: 'checkout_cart'
  delete '/cart', to: 'carts#delete_item_from_cart', as: 'cart'

  resources :items

  resources :admins

  resources :users do
    resources :orders
  end

end
