FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.unique.email }
    end
  end
