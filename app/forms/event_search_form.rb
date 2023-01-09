class EventSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :page, :integer
  attr_reader :hosted_date

  def search
    Event.search(
      keyword_for_search,
      includes: [:hosted_dates],
      where: { hosted_dates: range_of_hosted_date,
               is_published: true },
      page: page,
      per_page: 10
    )
  end

  def hosted_date=(new_hosted_date)
    @hosted_date = new_hosted_date.in_time_zone
  end

  private

  def keyword_for_search
    keyword.presence || '*'
  end

  def range_of_hosted_date
    if hosted_date.nil?
      { gte: Time.current.midnight }
    else
      { gte: hosted_date, lt: hosted_date.tomorrow }
    end
  end
end
