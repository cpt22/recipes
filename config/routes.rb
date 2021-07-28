Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'home#index'

  resources :account, only: :index

  resources :categories, except: :show

  resources :home, only: :index

  resources :ingredients, except: :show

  resources :recipes

  resources :users, only: [:new, :show, :create]

end
