class ReservationsController < ApplicationController
  def new
  end

  def create(id:)
    event = Event.find(id)
    @reservation = current_user.reservations.build do |t|
      t.event = event
      t.comment = params[:reservation][:comment]
    end

    if @reservation.save
      redirect_to event, notice: 'イベントに参加しました'
    end
  end
end
