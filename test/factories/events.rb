FactoryBot.define do
  factory :event do
    name { 'バスソルト作り' }
    place { '金魚亭' }
    title { '心身共にリラックスできるバスソルトを作りましょう' }
    discription { '見た目も可愛くてリラックス以外の効能もあります' }
    price { 500 }
    required_time { 30 }
    capacity { 2 }
    is_published { true }
    association :owner

    trait :with_hosted_dates do
      after(:create) { |event| create_list(:hosted_date, 3, event: event) }
    end

    trait :reindex do
      after(:create) do |event, _evaluator|
        event.reindex(refresh: true)
      end
    end
  end
end
