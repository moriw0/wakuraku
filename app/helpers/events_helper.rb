module EventsHelper
  def format_date(date)
    "#{l(date.started_at, format: :long)} - #{l(date.ended_at, format: :short)}"
  end
end
