class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  permits :name, :place, :title, :discription, :price, :required_time, :is_published, :capacity, 
          hosted_dates_attributes: 
            [:id, :started_at, :ended_at, :_destroy]

  def new
    @event = current_user.created_events.build
    @event.hosted_dates.build
    @today = Date.today
  end

  def create(event)
    @event = current_user.created_events.build(event)

    if @event.save
      redirect_to @event, notice: '作成しました'
    else 
      render 'new'
    end
  end

  def show(id)
    @event = Event.find(id)
  end
end
