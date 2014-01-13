# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence (:user_email)  { |n| "user#{n}@lta.io" }

  factory :user do
    email                 { generate :user_email }
    password              "qweasd42"
    password_confirmation "qweasd42"

    trait (:root)         { role_cd 2 }
    trait (:moderator)    { role_cd 1 }
    trait (:confirmed)    { confirmed_at { DateTime.now }}

    factory :user_root,   traits: [:root, :confirmed]
    factory :user_modo,   traits: [:moderator, :confirmed]
    factory :confirmed_user, traits: [:confirmed]
  end
end
