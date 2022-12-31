class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  permits :name, :place, :title, :discription, :price, :required_time, :is_published, :capacity, images: [], image_ids: [],
          hosted_dates_attributes:
            %i[id started_at ended_at _destroy]

  def index
    @events = Event.with_recent_dates
  end

  def new
    @event = current_user.created_events.build
    @event.hosted_dates.build
    @today = Time.zone.today
  end

  def create(event:)
    @event = current_user.created_events.build(event)

    if @event.save
      redirect_to @event, notice: t(:notice_create)
    else
      @today = Time.zone.today
      render 'new'
    end
  end

  def show(id:)
    @event = Event.find(id)
  end

  def edit(id:)
    @event = current_user.created_events.find(id)
    @today = Time.zone.today
  end

  def update(id:, event:)
    @event = current_user.created_events.find(id)
    if @event.update(event)
      redirect_to @event, notice: t(:notice_update)
    else
      @today = Time.zone.today
      render 'edit'
    end
  end

  def destroy(id:)
    @event = current_user.created_events.find(id)
    @event.destroy!
    redirect_to events_path, notice: t(:notice_destroy)
  end
end
