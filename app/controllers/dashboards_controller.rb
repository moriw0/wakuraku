class DashboardsController < ApplicationController
  def reservation_index
    @reservations = current_user.created_event_reservations
  end

  def event_reservations(event_id)
    @event = Event.find(event_id)
    @reservations = @event.reservations
  end

  def event_index
    @events = current_user.created_events
  end

  def customer_index
    @customers = current_user.customers
  end

  def customer_reservations(id)
    @customer = User.find(id)
    @reservations = current_user.reservations_by_customer(id)
  end
end
