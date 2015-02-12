FactoryGirl.define do
  factory :user do
    username "LambPETAsAreTasty"
    first_name  "Roger"
    last_name "Federer"
    password "password"
    sequence(:street) { |n| "412#{n} Tasty Animals Lane" }
    city "Denver"
    state "Colorado"
    zipcode "80205"
    country "USA"
    sequence(:email) { |n| "person#{n}@gmail.com"}
    sequence(:credit_card_info) { |n| "1111222#{n}233334444" }
    role 0
  end

  factory :tenant do
    location "Shenzhen"
    organization "lucy"
  end

  factory :category do
    sequence(:name) { |n| "hot beverages#{n}" }
  end


  factory :item do
    sequence(:title) { |n| "espresso#{n}" }
    price 800
    description "European and obnoxious"
  end

  factory :order do
    user
    total_cost 8900
    status "completed"

    factory :order_with_user
  end

end
