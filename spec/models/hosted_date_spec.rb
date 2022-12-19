require 'rails_helper'

RSpec.describe HostedDate, type: :model do
  before do
    @event = create(:event)
  end

  it 'is valid when stated_at is after now' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.minute.from_now,
      ended_at: 1.hour.from_now
    )
    expect(hosted_date).to be_valid
  end

  it 'is invalid when stated_at is before now' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.minute.ago,
      ended_at: 1.hour.from_now
    )
    hosted_date.valid?
    expect(hosted_date.errors[:started_at]).to include('は現在時刻より後に設定してください')
  end

  it 'is valid when started_at is before ended_at' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.day.since(DateTime.parse('09:00')),
      ended_at: 1.day.since(DateTime.parse('10:00'))
    )
    expect(hosted_date).to be_valid
  end

  it 'is invalid when ended_at is before started_at' do
    hosted_date = @event.hosted_dates.build(
      started_at: 1.day.since(DateTime.parse('10:00')),
      ended_at: 1.day.since(DateTime.parse('09:00'))
    )
    hosted_date.valid?
    expect(hosted_date.errors[:started_at]).to include('は終了時間よりも前に設定してください')
  end

  it 'is valid when stared_at and ended_at are unique' do
    create(:hosted_date, :from_9_to_10, event: @event)
    hosted_date = build(:hosted_date, :from_10_to_11, event: @event)
    expect(hosted_date).to be_valid
  end

  it 'is invalid when both stared_at and ended_at are not unique' do
    create(:hosted_date, :from_9_to_10, event: @event)
    hosted_date = build(:hosted_date, :from_9_to_10, event: @event)
    hosted_date.valid?
    expect(hosted_date.errors[:event_id]).to include('内に既に存在する開催日時です。')
  end

  describe 'overlapping validation for the default held from 9:00 to 10:00' do
    before do
      create(:hosted_date, :from_9_to_10, event: @event)
    end

    context 'not overlapping' do
      it 'is valid when held from 8:00 to 9:00' do
        hosted_date = build(:hosted_date, :from_8_to_9, event: @event)
        expect(hosted_date).to be_valid
      end

      it 'is valid when held from 10:00 to 11:00' do
        hosted_date = build(:hosted_date, :from_10_to_11, event: @event)
        expect(hosted_date).to be_valid
      end
    end

    context 'overlapping' do
      it 'is invalid when held from 8:30 to 9:30' do
        hosted_date = build(:hosted_date, :from_8_30_to_9_30, event: @event)
        hosted_date.valid?
        expect(hosted_date.errors[:base]).to include('が既に存在する期間と重複しています。')
      end

      it 'is invalid when held from 8:50 to 10:10' do
        hosted_date = build(:hosted_date, :from_8_50_to_10_10, event: @event)
        hosted_date.valid?
        expect(hosted_date.errors[:base]).to include('が既に存在する期間と重複しています。')
      end

      it 'is invalid when held from 9:10 to 9:50' do
        hosted_date = build(:hosted_date, :from_9_10_to_9_50, event: @event)
        hosted_date.valid?
        expect(hosted_date.errors[:base]).to include('が既に存在する期間と重複しています。')
      end

      it 'is invalid when held from 9:30 to 10:30' do
        hosted_date = build(:hosted_date, :from_9_30_to_10_30, event: @event)
        hosted_date.valid?
        expect(hosted_date.errors[:base]).to include('が既に存在する期間と重複しています。')
      end
    end
  end
end
