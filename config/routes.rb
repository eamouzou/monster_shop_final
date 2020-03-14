Rails.application.routes.draw do

  get '/', to: 'welcome#index'

  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end

  get '/merchants/:merchant_id/items', to: 'items#index', as: 'merchant_items'
  post '/merchants/:merchant_id/items', to: 'items#create'
  get '/merchants/:merchant_id/items/new', to: 'items#new', as: 'new_merchant_item'

  get '/merchants', to: 'merchants#index', as: 'merchants'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new', as: 'new_merchant'
  get '/merchants/:id/edit', to: 'merchants#edit', as: 'edit_merchant'
  get '/merchants/:id', to: 'merchants#show', as: 'merchant'
  patch '/merchants/:id', to: 'merchants#update'
  put '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'

  # resources :items, only: [:index, :show, :edit, :update, :destroy] do
  #   resources :reviews, only: [:new, :create]
  # end

  post '/items/:item_id/reviews', to: 'reviews#create', as: 'item_reviews'
  get '/items/:item_id/reviews/new', to: 'reviews#new', as: 'new_item_review'
  get '/items', to: 'items#index', as: 'items'
  get '/items/:id/edit', to: 'items#edit', as: 'edit_item'
  get '/items/:id', to: 'items#show', as: 'item'
  patch '/items/:id', to: 'items#update'
  put '/items/:id', to: 'items#update'
  delete '/items/:id', to: 'items#destroy'

  # resources :reviews, only: [:edit, :update, :destroy]

  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'
  patch '/reviews/:id', to: 'reviews#update', as: 'review'
  put '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:quantity", to: "cart#edit_quantity"

  # resources :orders, only: [:new, :create, :show, :update]

  post '/orders', to: 'orders#create', as: 'orders'
  get '/orders/new', to: 'orders#new', as: 'new_order'
  get '/orders/:id', to: 'orders#show', as: 'order'
  patch '/orders/:id', to: 'orders#update'
  put '/orders/:id', to: 'orders#update'


  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get "/profile", to: 'users#show'
  get "/profile/:profile_id/edit", to: "users#edit"

  get "/profile/:profile_id/edit_password", to: 'users#edit_password'
  patch "/profile/:profile_id", to: 'users#update_password'
  get '/profile/orders/:id', to: 'orders#show'

  patch '/profile', to: 'users#update'
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/', to: 'sessions#destroy'

  # namespace :merchant do
  #only merchant users will be able to reach this resource
    get '/merchant/dashboard', to: 'merchant/dashboard#show', as: 'merchant_dashboard'
    get '/merchant/:merchant_id/dashboard', to: "merchant/dashboard#show"
    get '/merchant/:merchant_id/items', to: "merchant/items#index"
    get '/merchant/:merchant_id/discounts', to: 'merchant/discounts#index'
    get '/merchant/:merchant_id/discounts/new', to: 'merchant/discounts#new'
    get '/merchant/:merchant_id/discounts/:discount_id/edit', to: 'merchant/discounts#edit'
    patch '/merchant/:merchant_id/discounts/:discount_id', to: 'merchant/discounts#update'
    get '/merchant/:merchant_id/discounts/:discount_id', to: 'merchant/discounts#show'
    post '/merchant/:merchant_id/discounts', to: 'merchant/discounts#create'
    delete '/merchant/:merchant_id/discounts/:discount_id', to: 'merchant/discounts#destroy'
  # end

  # namespace :admin do
  #only admin users will be able to reach this resource
    get '/admin/dashboard', to: "admin/dashboard#show", as: 'admin_dashboard'
    get '/admin/merchants', to: "admin/merchants#index", as: 'admin_merchants'
    get '/admin/profile/:id', to: "admin/users#show", as: 'admin'
    patch '/admin/orders/:id', to: "admin/dashboard#update"
    patch '/admin/merchants/:id', to: "admin/merchants#update"

    get '/admin/merchants/:merchant_id', to: "admin/dashboard#show"
    get '/admin/merchants/:merchant_id/orders/:order_id', to: "admin/orders#show"
    get '/admin/merchants/:merchant_id/items', to: "admin/items#index"
    patch '/admin/merchants/:merchant_id/items/:item_id', to: "admin/items#update"
    patch '/admin/merchants/:merchant_id/orders/:order_id/items/:item_id', to: "admin/items#update"
    delete '/admin/merchants/:merchant_id/items/:item_id', to: "admin/items#destroy"
    get '/admin/merchants/:merchant_id/items/new', to: "admin/items#new"
    post '/admin/merchants/:merchant_id/items', to: 'admin/items#create'
    get '/admin/merchants/:merchant_id/items/:item_id/edit', to: 'admin/items#edit'
    get '/admin/users', to: 'admin/admin_users#index', as: 'admin_users'
    get '/admin/users/:user_id', to: 'admin/admin_users#show'
  # end
end
