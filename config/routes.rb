Rails.application.routes.draw do

  root to: 'users#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  resources :loan_requests, only: [:new, :create, :show] do
    member do
      patch :approve
      patch :reject
      patch :adjust
      patch :repay
    end
  end

  resources :users
  get 'dashboard', to: 'users#dashboard'
end