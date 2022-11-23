Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: :show do
    resources :reservations, only: [:index, :show, :update, :destroy]
    get 'reservations/canceled', to: 'reservations#canceled_index', as: 'canceled_reservations'
  end

  resources :events do
    resources :reservations, only: [:new, :create]
    get 'reservations', to: 'dashboards#event_reservations'
  end

  scope '/dashboard' do
    get 'reservations', to: 'dashboards#reservation_index', as: 'dashboard_reservations'
    get 'events', to: 'dashboards#event_index', as: 'dashboard_events'
    get 'customers', to: 'dashboards#customer_index', as: 'dashboard_customers'
    get 'customers/:id', to: 'dashboards#customer_reservations', as: 'customer_reservations'
  end
end
