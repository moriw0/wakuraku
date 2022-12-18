FactoryBot.define do
  factory :hosted_date do
    sequence(:started_at) { |n| 1.day.since(DateTime.parse("0#{n}:00")) }
    sequence(:ended_at) { |n| 1.day.since(DateTime.parse("0#{n+1}:00")) }
    association :event
  end
end
