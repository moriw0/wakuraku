require 'rails_helper'

RSpec.describe 'Retirements', type: :system, js: true do
  let(:owner) { create(:user) }
  let!(:event) { create(:event, owner: owner) }
  let!(:hosted_date_1) { create(:hosted_date, :from_8_to_9, event: event) }
  let!(:hosted_date_2) { create(:hosted_date, :from_10_to_11, event: event) }
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  before do
    user_1.reservations.create(
      event: event,
      hosted_date: hosted_date_1
    )
    user_2.reservations.create(
      event: event,
      hosted_date: hosted_date_2
    )
  end

  scenario 'owner can retire after hide the event' do
    sign_in owner
    visit root_path
    click_link 'プロフィール'
    click_link 'プロフィールを編集する'
    click_link '退会する'
    expect(page).to have_content '退会の確認'
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会することができませんでした'
    expect(page).to have_content '公開中の未終了イベントが存在します'

    visit edit_event_path(event)
    select '非公開', from: '公開設定'
    click_button '更新する'

    visit new_retirements_path
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会完了しました'
    expect(page).to have_content 'ログイン'
    expect(owner.reload).to be_discarded
  end

  scenario 'owner can retire after the event hosted' do
    sign_in owner
    visit root_path
    click_link 'プロフィール'
    click_link 'プロフィールを編集する'
    click_link '退会する'
    expect(page).to have_content '退会の確認'
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会することができませんでした'
    expect(page).to have_content '公開中の未終了イベントが存在します'

    travel 2.days
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会完了しました'
    expect(page).to have_content 'ログイン'
    expect(owner.reload).to be_discarded
  end

  scenario 'user can retire after cancel the event' do
    sign_in user_1
    visit root_path
    click_link 'プロフィール'
    click_link 'プロフィールを編集する'
    click_link '退会する'
    expect(page).to have_content '退会の確認'
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会することができませんでした'
    expect(page).to have_content '未終了の参加イベントが存在します'

    visit user_reservation_path(user_id: user_1, id: user_1.reservations.first)
    click_link 'この予約をキャンセルする'
    page.accept_confirm

    visit new_retirements_path
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会完了しました'
    expect(page).to have_content 'ログイン'
    expect(user_1.reload).to be_discarded
  end

  scenario 'user can retire after the event hosted' do
    sign_in user_1
    visit root_path
    click_link 'プロフィール'
    click_link 'プロフィールを編集する'
    click_link '退会する'
    expect(page).to have_content '退会の確認'
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会することができませんでした'
    expect(page).to have_content '未終了の参加イベントが存在します'

    travel 2.days
    click_link '退会する'
    page.accept_confirm
    expect(page).to have_content '退会完了しました'
    expect(page).to have_content 'ログイン'
    expect(user_1.reload).to be_discarded
  end
end
