Rails.application.routes.draw do

  resources :contacts, only: [:new,:create]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :categories
  resources :orders do 
    resources:orderitems
  end

  devise_for :users do 
    resources :orders 
  end

  get '/checkout' => 'cart#createOrder'


  resources :items
  get 'cart/index'
 
  root 'static_pages#home'
  get '/about' => 'static_pages#about'

  get '/login' => 'user#login' 
  get '/logout' => 'user#logout'

  get '/cart/clear', to: 'cart#clearCart'
  get '/cart', to: 'cart#index'

  get '/cart/:id', to: 'cart#add'
  

  
  get '/cart/remove/:id' => 'cart#remove'

  get '/cart/increase/:id' => 'cart#increase'

  get '/cart/decrease/:id' => 'cart#decrease'

  post '/search' => 'items#search'

  get 'category/:title', to: 'static_pages#category',as: 'category_title'


  post 'payment',to: 'cart#payment',as: 'payment'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
