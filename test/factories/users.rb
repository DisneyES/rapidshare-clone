FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email { Faker::Internet.email }

    trait :with_password do
      password "123456"
      password_confirmation "123456"
    end
  end
end
