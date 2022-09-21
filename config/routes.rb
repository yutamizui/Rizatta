Rails.application.routes.draw do

  root to: 'reservations#index'

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
  resources :reservations do
    collection do
      get :list
    end
  end
  resources :rooms
  resources :timeframes do
    collection do
      post :single_duplicate
      post :multiple_duplicate
    end
  end
  resources :users
  resources :tickets
  resources :sales_items do
    collection do
      get :list
      post :purchase
    end
  end
  resources :staffs
  get "locale" => "application#locale", as: "locale"
end
