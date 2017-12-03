Rails.application.routes.draw do
  devise_for :users
  resources :users
  # get 'welcome/index'
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end
  root 'welcome#index'
  resources :charges
end