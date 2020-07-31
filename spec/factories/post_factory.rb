FactoryBot.define do
  factory :post do
    created_at { Time.at(Time.now.to_i - rand(0..16070400)).to_datetime.iso8601 }
    replies { rand(0..50) }
    title { Faker::Book.title }
    username { Faker::Internet.username }
  end
end
