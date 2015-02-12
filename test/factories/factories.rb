FactoryGirl.define do
<<<<<<< HEAD
  factory :user do
    username "LambPETAsAreTasty"
    first_name  "Roger"
    last_name "Federer"
    password "password"
    sequence(:address) { |n| "412#{n} Tasty Animals Lane" }
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
    image "default.jpg"

    factory :category_with_items do
      transient do
        item_count 1
      end
    end
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
  end

  factory :admin do
    username "JeffWan"
    password "password"
    email "IEnjoyCagedEggs@gmail.com"
  end

end
