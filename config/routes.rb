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
    get 'dashboards/reservations', to: 'dashboards#reservation_index', as: 'dashboard_reservations'
    get 'dashboards/events', to: 'dashboards#event_index', as: 'dashboard_events'
    get 'dashboards/customers', to: 'dashboards#customer_index', as: 'dashboard_customers'
  end

  resources :events do
    resources :reservations, only: [:new, :create]
    get 'reservations', to: 'dashboards#event_reservations', as: 'dashboard_reservations'
  end

end
