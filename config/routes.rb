Rails.application.routes.draw do
  resources :orders
  devise_for :users
  resources :users
  resources :dishes
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end
  # get 'welcome/index'
  root 'welcome#index'
  resources :charges
end