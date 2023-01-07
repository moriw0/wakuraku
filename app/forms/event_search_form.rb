class EventSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :page, :integer

  def search
    Event.search(
      keyword_for_search,
      page: page,
      per_page: 10
    )
  end

  private

  def keyword_for_search
    keyword.presence || '*'
  end
end
