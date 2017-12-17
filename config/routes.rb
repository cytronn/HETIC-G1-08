Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers  => { :registrations => 'custom_devise/registrations' }
  resources :users
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
  end
  resources :orders, only: [:index, :show, :edit, :update, :destroy], param: :slug do
    post 'accept'
    post 'reject'
  end
  resources :organizations, only: [:new, :create]
  resources :dishes, param: :slug do
    collection do
      get "filter/*tags", to: 'dishes#index', as: 'tags'
    end
    resources :orders, only: [:new, :create], param: :slug do
      get 'pay' 
      post 'pay'
    end
  end
  
  root 'welcome#index'
end