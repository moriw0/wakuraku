module ReservationsHelper
  def format_updated_date_by(date)
    l(date.updated_at, format: :default)
  end

  def date_options_by(event)
    options_for_select(event.hosted_dates.map { |date| [format_date(date), date.id] })
  end
end
