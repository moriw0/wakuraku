require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with an email and password' do
    user = User.new(
      email: 'test@example.com',
      password: '112233445566'
    )
    user.valid?
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(
      email: nil
    )
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません。")
  end
  
  it 'is invalid without a password' do
    user = User.new(
      password: nil
    )
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません。")
  end

  it "is invalid with a duplicate email address" do
    User.create(
      email: "taro@example.com",
      password: "112233445566"
    )
    user = User.new(
      email: "taro@example.com",
      password: "112233445566"
    )
    user.valid?
    expect(user.errors[:email]).to include{"はすでに登録済みです。"}
  end
end
