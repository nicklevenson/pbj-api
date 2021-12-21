FactoryBot.define do
  factory :tag do
    kind { 0 }

    trait :genre do
      kind { 1 }
      name { Faker::Music.genre }
    end

    trait :instrument do
      kind { 2 }
      name { Faker::Music.instrument }
    end
  end
end
