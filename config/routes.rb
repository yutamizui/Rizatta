Rails.application.routes.draw do
 
  devise_scope :user do
    root :to => "users/sessions#new"
  end

  devise_for :companies, controllers: {
    sessions:      'companies/sessions',
    passwords:     'companies/passwords',
    registrations: 'companies/registrations'
  }
  devise_for :staffs, controllers: {
    sessions:      'staffs/sessions',
    passwords:     'staffs/passwords',
    registrations: 'staffs/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  resources :companies
  resources :branches
  resources :reservations
  resources :rooms
  resources :timeframes
  resources :users
  resources :staffs, only: [:index]
  get "locale" => "application#locale", as: "locale"
end
