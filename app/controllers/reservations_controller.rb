class ReservationsController < ApplicationController
  permits :comment, :hosted_date_id

  def index
    @reservations = current_user.reservations.with_recent_associations
  end

  def canceled_index
    @reservations = current_user.reservations.recent_canceled
  end

  def new(event_id:, date_id:)
    @event = Event.find(event_id)
    @date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build
  end

  def create(event_id:, date_id:, reservation:)
    @event = Event.find(event_id)
    @date = HostedDate.find(date_id)
    @reservation = current_user.reservations.build(reservation) do |t|
      t.event = @event
      t.hosted_date = @date
    end

    if @reservation.save
      redirect_to user_reservations_path(current_user), notice: 'ココロミを予約しました'
    else
      flash.now[:error] = 'ココロミを予約できませんでした'
      render 'events/show'
    end
  end

  def show(id:)
    @reservation = Reservation.find(id)
    @event = Event.find(@reservation.event_id)
    @date = HostedDate.find(@reservation.hosted_date_id)
  end

  def update(id:, reservation:)
    @reservation = Reservation.find(id)

    if @reservation.update(reservation)
      redirect_to user_reservations_path, notice: '予約を変更しました'
    else
      @event = Event.find(@reservation.event_id)
      @date = HostedDate.find(@reservation.hosted_date_id)
      flash.now[:error] = '予約を変更できませんでした'
      render 'show'
    end
  end

  def destroy(id:)
    @reservation = Reservation.find(id)
    @reservation.update(is_canceled: true)
    redirect_to user_reservations_path, notice: '予約をキャンセルしました'
  end
end
