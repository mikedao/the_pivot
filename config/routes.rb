Rails.application.routes.draw do

  # get 'tenants/index'
  #
  # get 'tenants/show'
  #
  root 'welcome#index'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get 'cart_items/create'




  post '/carts', to: 'carts#create', as: 'carts'
  get '/cart', to: 'carts#showcart', as: 'showcart'
  post '/cart', to: 'carts#checkout_cart', as: 'checkout_cart'
  delete '/cart', to: 'carts#delete_item', as: 'cart'
  put '/cart', to: 'carts#update_item_quantity', as: 'update_item_quantity'

  namespace :admin do
    get '/dashboard', to: 'base#dashboard'
    # resources :categories
    # resources :items
    # resources :orders
  end

  resources :users do
    resources :orders
  end

  # resources :tenants, path: "", param: :tenant

  scope ':tenant', module: 'tenants' do
    get '/' => 'items#index', as: :tenant
    resources :categories
    resources :items
  end


  match '/create_order', via: [:get], to: "orders#create"
end


#this maybe useful for multitenancy

# scope ':username ' do
#   resources :articles, :only => [:show, :index]
#
#   namespace :admin do
#     resources :articles, :except => [:show, :index]
#   end
# end
