class ReservationsController < ApplicationController
  before_action :set_event, only: [:new, :create]
  before_action :set_date, only: [:new, :create]
  before_action :set_reservation, only: [:show, :update, :destroy]
  permits :comment, :hosted_date_id
  
  def index
    @reservations = current_user.reservations.with_recent_associations
  end

  def canceled_index
    @reservations = current_user.reservations.recent_canceled
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

  def update(reservation:)
    if @reservation.update(reservation)
      redirect_to user_reservations_path, notice: '予約を変更しました'
    else
      @event = Event.find(@reservation.event_id)
      @date = HostedDate.find(@reservation.hosted_date_id) 
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
