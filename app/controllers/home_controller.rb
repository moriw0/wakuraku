class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @events = Event.with_recent_dates
    authorize! :read, @events
  end
end
