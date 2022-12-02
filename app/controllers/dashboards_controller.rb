class DashboardsController < ApplicationController
  def reservation_index
    @reservations = current_user.created_event_reservations
  end

  def event_reservations(event_id)
    @event = Event.find(event_id)
    @reservations = @event.reservations
  end
end
