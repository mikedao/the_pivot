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

  factory :order do
    total_cost 8900
    status "completed"

    before(:create) do |order|
      order.user = create_list(:user, 1, username: "PETA4Lyfe")
    end
  end

  factory :item do
    sequence(:title) { |n| "espresso#{n}" }
    price 800
    description "We product only the finest blood diamonds in Sierra Leone. Diamond are forever."
    retired false

    before(:create) do |item|
      item.tenant = create_list(:tenant, 1, )
    end
  end

  factory :category do
    sequence(:name) { |n| "hot beverages#{n}" }
    description "European and obnoxious"
  end

  factory :order do
    user
    total_cost 8900
    status "completed"
  end
end
