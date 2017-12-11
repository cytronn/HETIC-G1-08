Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # authentification
  devise_for :users,
  :controllers  => {
    :registrations => 'custom_devise/registrations',
  }
  resources :users
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end

  #search by tags routes 
  get 'tags/*tag', to: 'dishes#index', as: "tag"
    
  # charges
  resources :charges, only: [:new, :create]

  # orders
  resources :orders, only: [:index, :show, :edit, :update, :destroy]
  resources :organizations, only: [:new, :create]
  # dishes with orders
  resources :dishes do
    resources :orders, only: [:new, :create] do
      get 'pay'
      post 'pay'
    end
  end
  
  # root
  root 'welcome#index'
end