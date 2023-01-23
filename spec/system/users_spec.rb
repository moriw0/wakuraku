require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user, nickname: '太郎') }

  scenario 'user can edit their profile' do
    sign_in user
    visit root_path

    click_link 'ダッシュボード'
    click_link 'プロフィール'
    click_link 'プロフィールを編集する'
    expect(page).to have_field('ニックネーム', with: '太郎')
    expect(page).to have_selector("img[src$='blank_user_image-b058cb0b0295da8f1273ca6812bda8c1.png']")

    fill_in 'ニックネーム', with: '二郎'
    images_path = Rails.root.join('spec/fixtures/files')
    find('form input[type="file"]', visible: :hidden).set("#{images_path}/avatar.jpg")
    click_button 'プロフィールを変更する'

    expect(page).to have_content 'アカウント情報を変更しました'
    expect(page).to have_content '二郎'
    expect(page).to have_selector("img[src$='avatar.jpg']")
  end
end
