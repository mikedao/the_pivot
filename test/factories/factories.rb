FactoryGirl.define do
  factory :user, aliases: [:fat_model, :skinny_controller] do
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
        create_list(:order, evaluator.orders_count, user: user)
      end
    end
  end

  factory :category do
    sequence(:name) { |n| "hot beverages#{n}" }
    image "default.jpg"

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
      # categories = create_list(:category, evaluator.category_count, :name => "hot beverages")
      # categories.each do |category|
        # CategoryItem.create(category: category, item: item)
      # end
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
