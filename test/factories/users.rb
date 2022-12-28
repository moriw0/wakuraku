FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:name) { |n| "tester#{n}" }
    sequence(:nickname) { |n| "nickname#{n}" }
    sequence(:phone_number) { |n| "090-1234-111#{n}" }
    password { '123456' }
  end
end
