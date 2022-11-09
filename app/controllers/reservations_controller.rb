class ReservationsController < ApplicationController
  def new(event_id:, date_id:)
    @event = Event.find(event_id)
    @date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build
  end

  def create(event_id:, date_id:)
    event = Event.find(event_id)
    date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build do |t|
      t.event = event
      t.comment = params[:reservation][:comment]
    end

    if @reservation.save
      redirect_to root_path, notice: 'イベントに参加しました'
    end
  end
end
