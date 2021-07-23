Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'home#index'

  resources :account, only: :index

  resources :categories

  resources :home, only: :index

  resources :ingredients

  resources :recipes

  resources :users, only: [:new, :create]

end
