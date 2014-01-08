# Read about factories at https://github.com/thoughtbot/factory_girl

EXAMPLE_LOCATION = [
  "paris, france",
  "Londong, united kingdoms",
  "Pekin, China",
  "paris, france, chatelet",
  "Africa"
]

EXAMPLE_LANG = [
  "English",
  "French",
  "German",
  "Other",
  "Spanish"
]

EXAMPLE_GENRE = [
  "News",
  "Sport",
  "Psychedelic",
  "Trance",
  "Rock",
  "Dubstep",
  "Choucroute",
  "Pate",
  "Tartiflette"
]

FactoryGirl.define do
  factory :station do
    name            { Faker::Company.name + " Radio" }
    description     { Faker::Lorem.paragraph 5 }
    location_list   { EXAMPLE_LOCATION.sample }
    lang_list       { EXAMPLE_LANG.sample }
    genre_list      { (0..3).to_a.map {EXAMPLE_GENRE.sample}.uniq.join "," }


    ignore do
      streams_count { rand(5) + 1 }
    end

    after(:create) do |station, evaluator|
      create_list(:stream, evaluator.streams_count, station: station)
    end
  end
end
