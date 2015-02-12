FactoryGirl.define do
  factory :user do
    username "LambPETAsAreTasty"
    first_name  "Roger"
    last_name "Federer"
    password "password"
    # sequence(:address) { |n| "412#{n} Tasty Animals Lane" }
    sequence(:email) { |n| "person#{n}@gmail.com"}
    sequence(:credit_card_info) { |n| "1111222#{n}233334444" }
    role 0

    factory :user_with_orders do

      transient do
        orders_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user: user)
      end
    end
  end

  factory :tenant do
    location "Shenzhen"
    organization "lucy"
  end

  factory :category do
    sequence(:name) { |n| "hot beverages#{n}" }

    factory :category_with_items do
      transient do
        item_count 1
      end

      after(:create) do |category, evaluator|
        create_list(:item, evaluator.item_count, :title => "cocoa", categories: [category])
      end
    end
  end


  factory :item do
    sequence(:title) { |n| "espresso#{n}" }
    price 800
    description "European and obnoxious"

    factory :item_with_categories do
      transient do
        category_count 1
      end

      after(:create) do |item, evaluator|
        create_list(:category, evaluator.category_count, :name => "hot beverages", items: [item])
      end
    end
  end

  factory :order do
    user
    total_cost 8900
    status "completed"

    # factory :order_with_user
    #
    # transient do
    #   user_count 1
    # end
    #
    # after(:create) do |order, evaluator|
    #   create_list(:user, evaluator.user_count, orders: [order])
    # end
  end
end
