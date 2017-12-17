Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers  => { :registrations => 'custom_devise/registrations', confirmations: 'confirmations' }
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
      get "filter/*tags/:date", to: 'dishes#index', defaults: {tags: 'all', date: 'all'}, as: 'filters'
    end
    resources :orders, only: [:new, :create], param: :slug do
      get 'pay' 
      post 'pay'
    end
  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all  
  
  root 'welcome#index'
end