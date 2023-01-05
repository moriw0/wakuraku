30.times do |n|
  name  = Faker::Name.name
  nickname = Faker::Name.first_name_neutral
  email = "guest#{n+1}@example.com"
  phone_number = Faker::PhoneNumber.cell_phone
  password = "password"
  User.create!(
    name: name,
    nickname: nickname,
    email: email,
    phone_number: phone_number,
    password:              password,
    password_confirmation: password
  )
end

dates = [{
  started_at: 1.day.since(Time.zone.parse('08:00')),
  ended_at: 1.day.since(Time.zone.parse('09:00'))},
{
  started_at: 1.day.since(Time.zone.parse('09:00')),
  ended_at: 1.day.since(Time.zone.parse('10:00'))
},
{
  started_at: 1.day.since(Time.zone.parse('10:00')),
  ended_at: 1.day.since(Time.zone.parse('11:00'))
}]

owners = User.order(created_at: 'desc').take(10)

owners.each do |owner|
  15.times do |n|
    name = "楽しいココロミ#{n} by #{owner.nickname}"
    place = Faker::Address.community
    title = "おかげ様で開催回数#{n}回!"
    discription = Faker::Lorem.paragraph

    event = owner.created_events.create!(
    name: name,
    place: place,
    title: title,
    discription: discription,
    price: 500,
    required_time: 30,
    is_published: true,
    capacity: 10
    )

    dates.each do |date|
      event.hosted_dates.create!(
        started_at: date[:started_at],
        ended_at: date[:ended_at]
      )
    end
  end
end

guests = User.order(created_at: 'desc').select { |user| user.created_events.blank? }.take(20)

guests.each do |guest|
  owners.each do |owner|
    owner.created_events.each do |event|
      event.reservations.create!(
        user: guest,
        hosted_date: event.hosted_dates[rand(3)]
      )
    end
  end
end
