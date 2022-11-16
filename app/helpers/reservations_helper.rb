module ReservationsHelper
  def format_created_date_by(date)
    l(date.created_at, format: :default)
  end
end
