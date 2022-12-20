FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { '123456' }
  end
end
