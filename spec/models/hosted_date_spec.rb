require 'rails_helper'

RSpec.describe HostedDate, type: :model do
  before do
    @event = FactoryBot.create(:event)
  end

  it 'is valid when started_at is earlier then ended_at' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.day.since(DateTime.parse("09:00")),
      ended_at: 1.day.since(DateTime.parse("10:00")),
    )
    expect(hosted_date).to be_valid
  end

  it 'is invalid when ended_at is earlier than started_at' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.day.since(DateTime.parse("10:00")),
      ended_at: 1.day.since(DateTime.parse("09:00")),
    )
    hosted_date.valid?
    expect(hosted_date.errors[:started_at]).to include('は終了時間よりも前に設定してください')
  end
end
