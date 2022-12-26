require 'rails_helper'

RSpec.describe "Dashboards", type: :system do
  let(:owner) { create(:user) }
  let!(:event) { create(:event, owner: owner) }
  let!(:hosted_date1) { create(:hosted_date, :from_8_to_9, event: event) }
  let!(:hosted_date2) { create(:hosted_date, :from_10_to_11, event: event) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    user1.reservations.create(
      event: event,
      hosted_date: hosted_date1
    )
    user2.reservations.create(
      event: event,
      hosted_date: hosted_date2
    )
    sign_in owner
    visit root_path
  end
  
  scenario 'owner gets #reservation_index' do
    click_link 'つくったココロミの予約一覧'
    expect(page).to have_content 'つくったココロミの予約一覧'

    within all('tr')[1] do
      expect(page).to have_content 'バスソルト作り'
      expect(page).to have_content '08:00 - 09:00'
      expect(page).to have_content user1.name
    end
    within all('tr')[2] do
      expect(page).to have_content 'バスソルト作り'
      expect(page).to have_content '10:00 - 11:00'
      expect(page).to have_content user1.name
    end
  end
  scenario 'owner gets #event_reservations' do 
  end

  scenario 'owner gets #event_index' do 
  end

  scenario 'owner gets #customer_index' do 
  end

  scenario 'owner gets #customer_reservations' do 
  end
end
