Rails.application.routes.draw do
  devise_for :users
  # get 'welcome/index'
  as :user do 
    get 'profile/edit' => 'devise/registrations#edit'
  end

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing
end
