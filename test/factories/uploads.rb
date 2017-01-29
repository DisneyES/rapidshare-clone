FactoryGirl.define do
  factory :upload do
    access_token { Faker::Number.hexadecimal(10) }
    association :user

    trait :with_file do
      file { Rack::Test::UploadedFile.new("test/fixtures/sample.png", "image/png") }
      content_type "image/png"
    end
  end
end
