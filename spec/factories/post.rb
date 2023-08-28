FactoryBot.define do
  factory :post do
    body { Faker::Lorem.characters(number: 10) }
    
    trait :one_words do
      body { "1" }
    end
    trait :more_than_500_words do
      body { Faker::Lorem.characters(number: 51) }
    end
    association :end_user
  end
end
