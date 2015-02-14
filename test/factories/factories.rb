FactoryGirl.define do

  sequence :city do |n|
    "New York City #{n}"
  end

  sequence :email do |n|
    "ILikeKumqutas#{n}@gmail.com"
  end

  factory :user do
    username "LambPETAsAreTasty"
    first_name  "Roger"
    last_name "Federer"
    password "password"
    sequence(:street) { |n| "412#{n} Tasty Animals Lane" }
    city
    email
    state "NY"
    zipcode "10003"
    country "USA"
    sequence(:credit_card_info) { |n| "1111222#{n}233334444" }

    factory :user_as_tenant do

      before(:create) do |user|
        user.tenant << create(:tenant)
      end
    end
  end

  factory :tenant do
    location "Shenzhen"
    organization "lucy"
  end

  factory :category do
    sequence(:name) { |n| "Public Works#{n}" }
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
    price 801
    description "We produce only the finest blood diamonds in Sierra Leone.
                Diamond are forever."
    retired false
    repayment_rate 3

    before(:create) do |item|
      item.tenant = create(:tenant)
    end

    before(:create) do |item|
      item.categories << create_list(:category, 1, name: "Civic")
    end
  end

  factory :admin do
    username "JeffWan"
    password "password"
    email "IEnjoyCagedEggs@gmail.com"
  end

  factory :photo do
    image_file_name "bridge_of_some_kind"
    image_content_type "something that needs to be built"
    image_file_size 3

    before(:create) do |photo|
      photo.item << create(:item)
    end
  end
end
