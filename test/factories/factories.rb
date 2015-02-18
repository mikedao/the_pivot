FactoryGirl.define do

  sequence :city do |n|
    "New York City #{n}"
  end

  sequence :email do |n|
    "ILikeKumqutas#{n}@gmail.com"
  end

  sequence :first_name do |n|
    "Roger#{n}"
  end

  factory :user do
    sequence(:username) { |n| "LambPETAsAreTasty#{n}" }
    first_name
    last_name "Federer"
    password "password"
    sequence(:street) { |n| "412#{n} Tasty Animals Lane" }
    city "new york"
    sequence(:email) { |n| "test#{n}@test.com" }
    state "NY"
    zipcode "10003"
    country "USA"
    sequence(:credit_card_info) { |n| "1111222#{n}2333#{n + 3}4444" }

    factory :user_as_borrower do
      before(:create) do |user|
        user.tenant = create(:tenant)
      end
    end
  end

  factory :tenant do
    location "Shenzhen"
    sequence(:organization) { |n| "lucy#{n}" }
  end

  factory :category do
    sequence(:name) { |n| "Public Works#{n}" }
  end

  factory :order do
    sequence(:total_cost) { |n| 10000 + n * 100 }
    status "completed"

    before(:create) do |order|
      order.user = create(:user)
    end
  end

  factory :project do
    sequence(:title) { |n| "De Beers#{n}" }
    price 13000
    description "Conflict Diamonds are Forever. We artificially created demand
                for conflict diamonds through brilliant advertising campaigns."
    retired false
    repayment_rate 3

    before(:create) do |project|
      project.tenant = create(:tenant)
    end

    before(:create) do |project|
      project.categories << create(:category)
    end
  end

  factory :admin do
    username "admin"
    password "password"
    email "admin@admin.com"
  end

  factory :photo do
    image File.new("#{Rails.root}/app/assets/images/test_photo.jpg")
  end

  factory :loan do
    before(:create) do |loan|
      loan.project = create(:project)
      loan.order = create(:order)
    end
  end
end
