class DashboardsController < ApplicationController
  def reservation_index
    @reservations = Reservation.of_created_events_by(current_user)
  end

  def event_reservations(event_id)
    @event = Event.find(event_id)
    @reservations = @event.reservations
  end

  def event_index
    @events = current_user.created_events
  end

  def customer_index
    @customers = User.customers_of(current_user)
  end

  def customer_reservations(customer_id)
    @customer = User.find(customer_id)
    @reservations = current_user.reservations_by(@customer)
  end
end
