Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'
  root 'home#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, only: :show do
    get 'reservations/canceled', to: 'reservations#canceled_index', as: 'canceled_reservations'
    resources :reservations
  end

  resources :events do
    resources :reservations
  end
end
