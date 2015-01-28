FactoryGirl.define do
  factory :user do
    password "password"
    first_name  "Roger"
    last_name "Federer"
    sequence(:email) { |n| "person#{n}@gmail.com"}
    role 0
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
    user
    total_cost 8900
    status "completed"
  end
end
