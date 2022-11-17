class ReservationsController < ApplicationController
  before_action :set_event, only: [:new, :create]
  before_action :set_date, only: [:new, :create]
  before_action :set_reservation, only: [:show, :update, :destroy]
  permits :comment
  
  def index
    @reservations = current_user.reservations
  end

  def new
    @reservation = current_user.reservations.build
  end
  
  def create(reservation:)
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

  def show
    @event = Event.find(@reservation.event_id)
    @date = HostedDate.find(@reservation.hosted_date_id)
  end

  def update(event_id:, date_id:)
    if @reservation.update(event_id: event_id, hosted_date_id: date_id)
      redirect_to user_reservations_path, notice: '予約を変更しました'
    else
      flash.now[:error] = '予約を変更できませんでした'
      render 'show'
    end
  end

  def destroy
    @reservation.update(is_canceled: true)
    redirect_to user_reservations_path, notice: '予約をキャンセルしました'
  end

  private 

  def set_event(event_id:)
    @event = Event.find(event_id)
  end

  def set_date(date_id:)
    @date = HostedDate.find(date_id)
  end

  def set_reservation(id:)
    @reservation = Reservation.find(id)
  end
end
