class EventsController < ApplicationController
  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      # redirect_to @event, notice: "作成しました"
      redirect_to new_event_path, notice: "作成しました"
    else 
      render 'new'
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :place, :title, :discription, :price, :required_time, :is_published, :capacitiy
    )
  end
end
