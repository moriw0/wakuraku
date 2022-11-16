class ReservationsController < ApplicationController
  before_action :set_event_and_date, only: [:new, :create]
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
      # TODO: 参加したココロミ一覧実装後は遷移先を変更する
      redirect_to root_path, notice: 'ココロミを予約しました'
    else
      flash.now[:error] = 'ココロミを予約できませんでした'
      render 'events/show'
    end
  end

  private 
  
  def set_event_and_date(event_id:, date_id:)
    @event = Event.find(event_id)
    @date = HostedDate.find(date_id)
  end
end
