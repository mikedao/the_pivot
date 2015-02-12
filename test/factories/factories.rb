FactoryGirl.define do

  factory :user, aliases: [:fat_model, :skinny_controller] do
    username "ILikeHospices"
    password "password"
    first_name  "Atul"
    last_name "Gawande"
    sequence(:email) { |n| "person#{n}@gmail.com"}
    role 0
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
