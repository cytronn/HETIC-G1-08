Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :dishes
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end

  get 'tags/*tag', to: 'dishes#index', as: "tag"
  
  # get 'welcome/index'
  root 'welcome#index'
  resources :charges
end