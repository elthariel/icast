# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :station_details do
    station       { Station.all.sample }
    website       { "http://www.#{Faker::Internet.domain_name}" }
    email         { Faker::Internet.email }
    description   { Faker::Lorem.paragraph rand(10) }
    lineup        { Faker::Lorem.paragraph rand(10) }
    origin        "seeds"
  end
end
