FactoryBot.define do
  factory :event do
    name { 'バスソルト作り' }
    place { '金魚亭' }
    title { '心身共にリラックスできるバスソルトを作りましょう' }
    discription { '見た目も可愛くてリラックス以外の効能もあります' }
    price { 500 }
    required_time { 30 }
    capacity { 5 }
    is_published { true }
    association :owner
  end
end
