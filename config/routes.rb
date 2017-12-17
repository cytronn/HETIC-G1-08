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
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
  end

  # filtering dishes index
  get 'dishes/t=:tag/d=:date', to: 'dishes#index', defaults: { tag: 'all', date: 'all' },  as: "filter"
    
  resources :orders, only: [:index, :show, :edit, :update], param: :slug

  # orders
  resources :orders, only: [:index, :show, :edit, :update, :destroy]
  resources :organizations, only: [:new, :create]
  # dishes with orders
  resources :dishes, param: :slug do
    resources :orders, only: [:new, :create], param: :slug do
      get 'pay' 
      post 'pay'
    end
  end
  
  root 'welcome#index'
end