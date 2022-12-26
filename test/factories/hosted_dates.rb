FactoryBot.define do
  factory :hosted_date do
    started_at = 1.day.since(Time.zone.parse('00:00'))
    ended_at = 1.day.since(Time.zone.parse('01:00'))
    sequence(:started_at) { |n| started_at + n.hour }
    sequence(:ended_at) { |n| ended_at + n.hour }
    association :event

    trait :from_9_to_10 do
      started_at { 1.day.since(Time.zone.parse('09:00')) }
      ended_at { 1.day.since(Time.zone.parse('10:00')) }
    end

    trait :from_8_to_9 do
      started_at { 1.day.since(Time.zone.parse('08:00')) }
      ended_at { 1.day.since(Time.zone.parse('09:00')) }
    end

    trait :from_10_to_11 do
      started_at { 1.day.since(Time.zone.parse('10:00')) }
      ended_at { 1.day.since(Time.zone.parse('11:00')) }
    end

    trait :from_8_30_to_9_30 do
      started_at { 1.day.since(Time.zone.parse('08:30')) }
      ended_at { 1.day.since(Time.zone.parse('09:30')) }
    end

    trait :from_8_50_to_10_10 do
      started_at { 1.day.since(Time.zone.parse('08:50')) }
      ended_at { 1.day.since(Time.zone.parse('10:10')) }
    end

    trait :from_9_10_to_9_50 do
      started_at { 1.day.since(Time.zone.parse('09:10')) }
      ended_at { 1.day.since(Time.zone.parse('09:50')) }
    end

    trait :from_9_30_to_10_30 do
      started_at { 1.day.since(Time.zone.parse('09:30')) }
      ended_at { 1.day.since(Time.zone.parse('10:30')) }
    end
  end
end
