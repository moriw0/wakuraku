require 'rails_helper'

RSpec.describe 'Events', type: :system do
  let(:user) { create(:user) }

  scenario 'user creates a new event' do
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'

    expect {
      click_link 'ココロミをつくる'
      fill_in '名前', with: 'バスソルト作り'
      fill_in 'タイトル', with: '心身共にリラックスできるバスソルトを作りましょう'
      fill_in '詳細', with: '見た目も可愛くてリラックス以外の効能もあります'
      fill_in '場所', with: '金魚亭'
      fill_in '価格', with: 500
      fill_in '所要時間', with: 30
      fill_in '定員', with: 5
      fill_in 'event[hosted_dates_attributes][0][started_at]', with: 1.day.since(DateTime.parse('09:00'))
      fill_in 'event[hosted_dates_attributes][0][ended_at]', with: 1.day.since(DateTime.parse('10:00'))
      click_button '登録する'

      expect(page).to have_content '作成しました'
      expect(page).to have_content '予約する'
      expect(page).to have_content user.nickname.to_s
    }.to change(user.created_events, :count).by(1)
  end
end
