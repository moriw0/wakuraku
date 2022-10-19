class EventsController < ApplicationController
skip_before_action :authenticate_user!, only: :show

  def new
    @event = current_user.created_events.build
    3.times { @event.hosted_dates.build }
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "作成しました"
    else
      render :new, alert: "登録できませんでした。入力内容をご確認のうえ再度お試しください"
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(
      :name,
      :place,
      :title,
      :discription,
      :price,
      :required_time,
      :is_published,
      :capacitiy,
      hosted_dates_attributes: [:start_at, :end_at, :_destroy]
    )
  end
end
