Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show]
  resources :friend_requests, only: [:create, :destroy] do
    member do 
      post "approve"
    end
  end

  root 'users#index'
end
