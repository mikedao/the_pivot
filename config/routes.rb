Rails.application.routes.draw do
  get 'cart_items/create'

   root 'welcome#index'

   post '/login', to: 'sessions#create'

   delete '/logout', to: 'sessions#destroy', as: 'logout'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

   resources :items
   resources :cart_items
   resources :orders
end
