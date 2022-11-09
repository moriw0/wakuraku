class ReservationsController < ApplicationController
  permits :comment

  def new(event_id:, date_id:)
    @event = Event.find(event_id)
    @date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build
  end

  def create(event_id:, date_id:, reservation:)
    event = Event.find(event_id)
    date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build(reservation) do |t|
      t.event = event
      t.hosted_date = date
    end

    if @reservation.save
      redirect_to root_path, notice: 'イベントに参加しました'
    end
  end
end
