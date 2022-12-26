FactoryBot.define do
  factory :reservation do
    comment { 'よろしくお願いします。楽しみです。' }
    association :event
    association :hosted_date
    association :user
  end
end
