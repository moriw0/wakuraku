require 'rails_helper'

RSpec.describe "Reservations", type: :system, js: true do
  context 'when user signs in' do
    let(:owner) { create(:user) }
    let!(:event) { create(:event, owner: owner) }
    let!(:hosted_date1) { create(:hosted_date, :from_8_to_9, event: event) }
    let!(:hosted_date2) { create(:hosted_date, :from_10_to_11, event: event) }
    let(:user) { create(:user) }

    scenario 'user reserves the event' do
      sign_in user
      visit root_path
      click_link 'バスソルト作り'

      expect {
        within '.dates-section' do
          within all('tr')[1] do
            expect(page).to have_content '10:00 - 11:00'
            expect(page).to have_content '残り2 人'
            click_link '予約する'
          end
        end

        fill_in '連絡事項', with: '楽しみにしています。'
        click_button '予約を確定する'
      }.to change(user.reservations, :count).by(1)

      expect(page).to have_content '予約しました'
      expect(page).to have_content '予約したココロミ'
      expect(page).to have_content '10:00 - 11:00'
    end

    context 'after user reserves' do
      before do
        user.reservations.create(
          event: event,
          hosted_date: hosted_date1,
        )

        sign_in user
      end

      scenario 'user can not click the link to the same hosted_date for reservation' do
        visit root_path
        click_link 'バスソルト作り'

        within '.dates-section' do
          within all('tr')[0] do
            expect(page).to have_content '08:00 - 09:00'
            expect(page).to have_content '残り1 人'
            expect(page).to have_selector '.disabled', text: '予約する'
          end
          within all('tr')[1] do
            expect(page).to have_content '10:00 - 11:00'
            expect(page).to have_content '残り2 人'
            expect(page).to have_content '予約する'
          end
        end
      end
  
      scenario 'user can change to other hosted_date for the reservation ' do
        visit root_path
        click_link '予約したココロミ'
        expect(page).to have_content 'バスソルト作り'
        expect(page).to have_content '08:00 - 09:00'
        click_link 'バスソルト作り'
        expect(page).to have_content '予約をキャンセルする'
        select '10:00 - 11:00', from: 'reservation[hosted_date_id]'
        click_button '予約内容を変更する'
        expect(page).to have_content '予約を変更しました'
        expect(page).to have_content '予約したココロミ'
        expect(page).to have_content 'バスソルト作り'
        expect(page).to have_content '10:00 - 11:00'
      end
    
      scenario 'user can cancel the reservation' do
        visit root_path
        click_link '予約したココロミ'
        expect(page).to have_content 'バスソルト作り'
        expect(page).to have_content '08:00 - 09:00'
        click_link 'バスソルト作り'
        expect(page).to have_button '予約内容を変更する'
        click_link 'この予約をキャンセルする'
        page.accept_confirm
        expect(page).to have_content '予約をキャンセルしました'
        expect(user.reservations.find_by(hosted_date: hosted_date1).is_canceled).to be_truthy 
        click_link 'キャンセル済み一覧'
        expect(page).to have_content 'バスソルト作り'
        expect(page).to have_content "キャンセル日：#{I18n.l  Time.current}"
      end
    end

    context 'after other users reserve' do
      let(:other_user1) { create(:user) }
      let(:other_user2) { create(:user) }
      
      scenario 'user can not click the link to no capacity' do
        other_user1.reservations.create(
          event: event,
          hosted_date: hosted_date2,
        )
        other_user2.reservations.create(
          event: event,
          hosted_date: hosted_date2,
        )

        sign_in user
        visit root_path
        click_link 'バスソルト作り'

        within '.dates-section' do
          within all('tr')[0] do
            expect(page).to have_content '08:00 - 09:00'
            expect(page).to have_content '残り2 人'
            expect(page).to have_content '予約する'
          end
          within all('tr')[1] do
            expect(page).to have_content '10:00 - 11:00'
            expect(page).to have_content '残り0 人'
            expect(page).to have_selector '.disabled', text: '予約する'
          end
        end
      end
    end
  end

  context 'when owner signs in' do
    let(:owner) { create(:user) }
    let(:event) { create(:event, owner: owner) }
    let!(:hosted_date1) { create(:hosted_date, :from_8_to_9, event: event) }
    let!(:hosted_date2) { create(:hosted_date, :from_10_to_11, event: event) }
    let(:user) { create(:user) }
    
    before do
      user.reservations.create(
        event: event,
        hosted_date: hosted_date1,
      )
    end

    scenario 'owner can not click the link for own event reservation' do
      sign_in owner
      visit root_path
      click_link 'バスソルト作り'

      within '.dates-section' do
        within all('tr')[0] do
          expect(page).to have_content '08:00 - 09:00'
          expect(page).to have_content '残り1 人'
          expect(page).to have_selector '.disabled', text: '予約する'
        end
        within all('tr')[1] do
          expect(page).to have_content '10:00 - 11:00'
          expect(page).to have_content '残り2 人'
          expect(page).to have_selector '.disabled', text: '予約する'
        end
      end
    end
  end
end
