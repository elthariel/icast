# Read about factories at https://github.com/thoughtbot/factory_girl

require 'base64'

FactoryGirl.define do
  factory :contribution do
    user                { User.all.sample }
    contributable_type  'Station'
    contributable_id    { Station.all.sample.id }

    data                { { name: "Contributed Name" } }
  end

  factory :contribution_new_content, class: "Contribution" do
    user                { User.all.sample }
    contributable_type  'Station'

    data                do
      attributes = FactoryGirl.attributes_for(:station)
      if attributes[:logo]
        attributes[:base64_logo] = {
          base64:        Base64.encode64(attributes[:logo].read),
          filename:      'redis.png',
          content_type:  'image/png'
        }
        attributes.delete :logo
      end
      attributes['details_attributes'] = FactoryGirl.attributes_for(:station_details, station: nil)
      attributes['streams_attributes'] = [ FactoryGirl.attributes_for(:stream, station: nil) ]
      attributes
    end
  end
end
