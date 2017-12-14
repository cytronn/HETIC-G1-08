Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :users
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
  end

  #search by tags routes 
  get 'dishes/t=:tag', to: 'dishes#index', as: "tag"
    
  resources :orders, only: [:index, :show, :edit, :update], param: :slug

  resources :dishes, param: :slug do
    resources :orders, only: [:new, :create], param: :slug do
      get 'pay' 
      post 'pay'
    end
  end
  
  root 'welcome#index'
end