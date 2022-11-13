class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  permits :name, :place, :title, :discription, :price, :required_time, :is_published, :capacity,
          hosted_dates_attributes:
            [:id, :started_at, :ended_at, :_destroy]

  def index
    @events = Event.with_recent_dates
  end

  def new
    @event = current_user.created_events.build
    @event.hosted_dates.build
    @today = Date.today
  end

  def create(event:)
    @event = current_user.created_events.build(event)

    if @event.save
      redirect_to @event, notice: '作成しました'
    else
      @today = Date.today
      render 'new'
    end
  end

  def show(id:)
    @event = Event.find(id)
  end

  def edit(id:)
    @event = current_user.created_events.find(id)
    @today = Date.today
  end

  def update(id:, event:)
    @event = current_user.created_events.find(id)
    if @event.update(event)
      redirect_to @event, notice: '更新しました'
    else
      @today = Date.today
      render 'edit'
    end
  end

  def destroy(id:)
    @event = current_user.created_events.find(id)
    @event.destroy!
    redirect_to events_path, notice: '削除しました'
  end
end
