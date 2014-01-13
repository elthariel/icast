# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contribution do
    user                { User.all.sample }
    contributable       { Station.all.sample }

    data                { { name: "Contributed Name" } }
  end

  factory :contribution_new_content, class: "Contribution" do
    user                { User.all.sample }
    contributable_type  { 'Station' }

    data                { FactoryGirl.attributes_for(:station) }
  end
end
