FactoryGirl.define do
  factory :user do
    password "password"
    first_name  "Roger"
    last_name "Federer"
    sequence(:email) { |n| "person#{n}@gmail.com"}
    role 0

    factory :user_with_orders do

      transient do
        orders_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user_id: user.id)
      end
    end
  end

  factory :category do
    sequence(:name) { |n| "hot beverages#{n}" }
    image "default.jpg"
  end

  factory :item do
    sequence(:title) { |n| "espresso#{n}" }
    price 800
    description "European and obnoxious"

    transient do
      category_count 0
    end

    after(:create) do |item, evaluator|
      create_list(:category, evaluator.category_count, :name => "hot beverages", items: [item])
    end
      # categories = create_list(:category, evaluator.category_count, :name => "hot beverages")
      # categories.each do |category|
        # CategoryItem.create(category: category, item: item)
      # end
  end

  factory :order do
    total_cost 8900
    status "completed"
    user

    # transient do
    #   user_id nil
    #   user_count 1
    # end

    # after(:create) do |order, evaluator|
    #   create_list(:user, user_count, :user_id => user_id, orders: [order])
    # end
  end
end
