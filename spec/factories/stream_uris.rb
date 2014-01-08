# Read about factories at https://github.com/thoughtbot/factory_girl

EXAMPLE_MIME = [
  'audio/mpeg',
  'audio/vorbis',
  'audio/opus',
  'audio/aac',
  'video/webm',
  'video/theora'
]

FactoryGirl.define do
  factory :stream_uri do
    stream            { Stream.all.sample }
    uri               { "http://#{Faker::Internet.domain_name}/stream#{rand 9999}.webm"}
    mime              { EXAMPLE_MIME.sample }
    video             { mime =~ /video/ }

    channels          { [1, 2, 4].sample }
    bitrate           { [32, 64, 128, 256, 512].sample }

  end
end
