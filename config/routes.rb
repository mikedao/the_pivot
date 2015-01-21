Rails.application.routes.draw do
   root 'welcome#index'

   post '/login', to: 'sessions#create'

   delete '/logout', to: 'sessions#destroy', as: 'logout'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

   resources :items
end
