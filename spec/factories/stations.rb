# Read about factories at https://github.com/thoughtbot/factory_girl


EXAMPLE_LANG      = [ "en", 'fr', 'sp', 'de', 'it', 'af' ]
EXAMPLE_COUNTRY   = [ 'us', 'gb', 'fr', 'de', 'sp', 'it' ]

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
    language        { EXAMPLE_LANG.sample }
    country         { EXAMPLE_COUNTRY.sample }
    genre_list      { (0..3).to_a.map {EXAMPLE_GENRE.sample}.uniq.join "," }

    logo            { File.open Rails.root.join('spec', 'fixtures', 'logo.png') }

    ignore do
      streams_count { rand(5) + 1 }
    end

    after(:create) do |station, evaluator|
      create_list(:stream, evaluator.streams_count, station: station)
    end

    details factory: :station_details
  end
end
