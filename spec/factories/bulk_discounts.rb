FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { Faker::Number.number(digits: 2) }
    quantity_threshold { Faker::Number.number(digits: 1) }
    merchant
  end
end
