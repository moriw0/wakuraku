require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with an email and password' do
    user = FactoryBot.build(:user)
    user.valid?
    expect(user).to be_valid
  end
  
  it 'is invalid without an email' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません。")
  end
  
  it 'is invalid without a password' do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません。")
  end

  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user)
    user = FactoryBot.build(:user)
    user.valid?
    expect(user.errors[:email]).to include{"はすでに登録済みです。"}
  end
end
