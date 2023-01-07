class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @event_search_form = EventSearchForm.new(event_search_form_params)
    @events = @event_search_form.search
  end

  private

  def event_search_form_params
    params.fetch(:event_search_form, {}).permit(:keyword).merge(page: params[:page])
  end
end
