Rails.application.routes.draw do
  devise_for :users
  
  root "cafes#index"
  post 'guest_sign_in', to: 'users#guest_sign_in'
  resources :cafes do
    resources :reviews, only: [:new, :create, :destroy]
    member do
      post 'add_to_favorites', to: 'favorites#create'
      delete 'remove_from_favorites', to: 'favorites#destroy'
    end
  end
  
  resources :users, only: [:show]
  
  resources :favorites, only: [:index, :create]

  post 'api/favorites', to: 'favorites#create_via_api'
end
