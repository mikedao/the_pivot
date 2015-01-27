FactoryGirl.define do
  factory :user do
    password "password"
    first_name  "Roger"
    last_name "Federer"
    sequence(:email) { |n| "person#{n}@gmail.com"}
    role 1
  end
end
