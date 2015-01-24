Rails.application.routes.draw do
  get 'cart_items/create'

  root 'welcome#index'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get '/cart', to: "sessions#showcart", as: "showcart"


  resources :categories

  resources :carts

  resources :items

  resources :admins

  resources :users do
    resources :orders
  end

end
