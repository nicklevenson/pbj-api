FactoryBot.define do
  factory :user do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }

    trait :incognito do
      incognito { true }
    end
  end
end
