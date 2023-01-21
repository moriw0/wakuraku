require 'rails_helper'

RSpec.describe 'Events', type: :system, js: true do
  let(:user) { create(:user) }

  scenario 'user creates a new event' do
    sign_in user
    visit root_path

    expect {
      click_link 'ダッシュボード'
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

      images_path = Rails.root.join('spec/fixtures/files')
      expect(find('.custom-file-label')).to have_content 'ファイル選択...'
      attach_file '画像（複数選択可）', [
        "#{images_path}/1000x800_2.1MB.png",
        "#{images_path}/1000x800_3.2MB.png",
        "#{images_path}/1000x800_4.2MB.png"
      ], make_visible: true
      within '#preview' do
        expect(all('.small')[0]).to have_content '1000x800_2.1MB.png'
        expect(all('.small')[1]).to have_content '1000x800_3.2MB.png'
        expect(all('.small')[2]).to have_content '1000x800_4.2MB.png'
      end
      expect(find('.custom-file-label')).to have_content '3個のファイルを選択しました'
      click_button '登録する'

      expect(page).to have_content '作成しました'
      expect(page).to have_content '予約する'
      expect(page).to have_content user.nickname.to_s
      expect(page).to have_selector("img[src$='1000x800_2.1MB.png']")
      expect(page).to have_selector("img[src$='1000x800_3.2MB.png']")
      expect(page).to have_selector("img[src$='1000x800_4.2MB.png']")

      image_link = all('.thumbnail')[0]['src']
      visit image_link
      expect(page).to have_selector("img[src$='1000x800_4.2MB.png']")
    }.to change(user.created_events, :count).by(1)
  end

  scenario 'user can not create a new event with no hosted_dates' do
    sign_in user
    visit root_path

    expect {
      click_link 'ダッシュボード'
      click_link 'ココロミをつくる'
      fill_in '名前', with: 'バスソルト作り'
      fill_in 'タイトル', with: '心身共にリラックスできるバスソルトを作りましょう'
      fill_in '詳細', with: '見た目も可愛くてリラックス以外の効能もあります'
      fill_in '場所', with: '金魚亭'
      fill_in '価格', with: 500
      fill_in '所要時間', with: 30
      fill_in '定員', with: 5
      click_button '登録する'

      expect(page).to have_content '開始日時が入力されていません'
      expect(page).to have_content '終了日時が入力されていません'
    }.to_not change(user.created_events, :count)
  end
end
