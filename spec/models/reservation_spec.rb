require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'with comments' do
    it 'is valid with a comment' do
      reservation = build(:reservation, comment: '楽しみです')
      reservation.valid?
      expect(reservation).to be_valid
    end
    
    it 'is valid with no comment' do
      reservation = build(:reservation, comment: nil)
      reservation.valid?
      expect(reservation).to be_valid
    end
  end

  context 'with hosted_dates' do
    let(:event) { create(:event) }
    let(:hosted_date1) { create(:hosted_date, :from_8_to_9, event: event) }
    let(:hosted_date2) { create(:hosted_date, :from_10_to_11, event: event) }
    let(:user) { create(:user) }

    it 'is valid with the different hosted_date' do
      user.reservations.create(
        event: event,
        hosted_date: hosted_date1
      )
      reservation = user.reservations.build(
        event: event,
        hosted_date: hosted_date2
      )
      expect(reservation).to be_valid
    end

    it 'is invalid with the same hosted_date' do
      user.reservations.create(
        event: event,
        hosted_date: hosted_date1
      )
      reservation = user.reservations.build(
        event: event,
        hosted_date: hosted_date1
      )
      reservation.valid?
      expect(reservation.errors[:hosted_date_id]).to include 'はすでに登録済みです' 
    end
  end
  
  context 'with is_canceled' do
    it 'is canceld when is_canceled is true' do
      reservation = build(:reservation, is_canceled: true)
      expect(reservation).to be_is_canceled
    end

    it 'is not canceld when is_canceled is false' do
      reservation = build(:reservation, is_canceled: false)
      expect(reservation).to_not be_is_canceled
    end
  end
end
