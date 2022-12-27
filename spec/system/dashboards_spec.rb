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
  
  scenario 'owner gets #reservation_index and then #event_reservations' do
    click_link 'つくったココロミの予約一覧'
    expect(page).to have_content 'つくったココロミの予約一覧'

    within all('tr')[1] do
      expect(find 'th').to have_content 'バスソルト作り'
      expect(all('td')[1]).to have_content '08:00 - 09:00'
      expect(all('td')[2]).to have_content user1.name
    end
    within all('tr')[2] do
      expect(find 'th').to have_content 'バスソルト作り'
      expect(all('td')[1]).to have_content '10:00 - 11:00'
      expect(all('td')[2]).to have_content user2.name
      click_link 'バスソルト作り'
    end
    within '.reservation-section' do
      expect(page).to have_content 'このココロミの予約一覧'
      within all('tr')[1] do
        expect(find 'th').to have_content 'バスソルト作り'
        expect(all('td')[1]).to have_content '08:00 - 09:00'
        expect(all('td')[2]).to have_content user1.name
      end
      within all('tr')[2] do
        expect(find 'th').to have_content 'バスソルト作り'
        expect(all('td')[1]).to have_content '10:00 - 11:00'
        expect(all('td')[2]).to have_content user2.name
      end
      expect(all('tr')[3]).to eq nil
    end
  end

  scenario 'owner gets #event_index and then #event_reservations' do
    click_link 'つくったココロミ一覧'
    expect(page).to have_content 'ココロミ一覧'

    within all('tr')[1] do
      expect(find 'th').to have_content 'バスソルト作り'
      expect(all('td')[0]).to have_content '500'
      expect(all('td')[2]).to have_content '2'
      expect(all('td')[3]).to have_content '公開'
      click_link 'バスソルト作り'
    end
    within '.reservation-section' do
      expect(page).to have_content 'このココロミの予約一覧'
      within all('tr')[1] do
        expect(find 'th').to have_content 'バスソルト作り'
        expect(all('td')[1]).to have_content '08:00 - 09:00'
        expect(all('td')[2]).to have_content user1.name
      end
      within all('tr')[2] do
        expect(find 'th').to have_content 'バスソルト作り'
        expect(all('td')[1]).to have_content '10:00 - 11:00'
        expect(all('td')[2]).to have_content user2.name
      end
      expect(all('tr')[3]).to eq nil
    end
  end

  scenario 'owner gets #customer_index and then #customer_reservations' do 
    click_link '顧客一覧'
    expect(page).to have_content '顧客一覧'

    within all('tr')[1] do
      expect(find 'th').to have_content user1.nickname
      expect(all('td')[0]).to have_content user1.name
      expect(all('td')[1]).to have_content user1.phone_number
      expect(all('td')[2]).to have_content user1.email
    end
    within all('tr')[2] do
      expect(find 'th').to have_content user2.nickname
      expect(all('td')[0]).to have_content user2.name
      expect(all('td')[1]).to have_content user2.phone_number
      expect(all('td')[2]).to have_content user2.email
    end
    expect(all('tr')[3]).to eq nil

    # save_and_open_page
    click_link user2.nickname
    within '.detail-section' do
      expect(page).to have_content '顧客情報詳細'
      within all('tr')[0] do
        expect(find 'td').to have_content user2.name
      end
      within all('tr')[1] do
        expect(find 'td').to have_content user2.nickname
      end
      within all('tr')[3] do
        expect(find 'td').to have_content user2.email
      end
    end
    within '.reservation-section' do
      expect(page).to have_content '顧客の予約一覧'
      within all('tr')[1] do
        expect(find 'th').to have_content 'バスソルト作り'
        expect(all('td')[1]).to have_content '10:00 - 11:00'
        expect(all('td')[2]).to have_content '予約'
      end
      expect(all('tr')[2]).to eq nil
    end
  end
end
