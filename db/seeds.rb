# lenders
100.times do |n|
  User.create!(
    username:              "lender#{n + 1}",
    email:                 "FlowersNPuppies-#{n + 1}@example.com",
    password:              "password",
    password_confirmation: "password",
    first_name:            Faker::Name.first_name,
    last_name:             Faker::Name.last_name,
    city:                  "Atlanta",
    state:                 "GA",
    zipcode:               50240,
    street:                "6#{n + 1}#{n + 2} Mockingbird Lane",
    country:               Faker::Address.country,
    credit_card_info:      "11112222333#{n + 1}44#{n + 2}4"
    )
end
lender = User.find_by(username: "lender1")

# tenants
10.times do |n|
  location =              "East Timor represent#{n + 1}"
  organization =          "Bridge Builders#{n + 1}"
  Tenant.create!(
    location:     location,
    organization: organization,
    active:       true,
    approved:     true
  )
end

# admin
Admin.create!(
  username: "admin",
  password: "password",
  email: "admin@admin.com"
)

Admin.create!(
username: "admin1",
password: "password",
email: "admin1@admin.com"
)

# borrowers
User.create!(
              username:              "borrower",
              first_name:            "Jorge",
              last_name:             "Telez-Borrower",
              email:                 "example_borrower@example.com",
              password:              "password",
              password_confirmation: "password",
              city:                  "Atlanta",
              state:                 "GA",
              street:                "5200 Buffington Road",
              zipcode:               30349,
              country:               "USA",
              credit_card_info:      "1111222233334444",
              tenant_id:             1
              )

Tenant.all.each do |tenant|
  2.times do |n|
    User.create!(
    username:              "borrower_#{tenant.id}_#{n}",
    first_name:            "Jorge",
    last_name:             "Telez",
    email:                 "example_#{tenant.id}_#{n}@example.com",
    password:              "password",
    password_confirmation: "password",
    city:                  "Atlanta",
    state:                 "GA",
    street:                "5200 Buffington Road",
    zipcode:               30349,
    country:               "USA",
    credit_card_info:      "1111222233334444",
    tenant_id:             tenant.id
    )
  end
end

# categories
people_category = Category.create!(
  name: "People"
)

people_category.photos << Photo.create!(
image: File.new("#{Rails.root}/app/assets/images/people_category.jpg")
)

env_category = Category.create!(
  name: "Environment"
)

env_category.photos << Photo.create!(
  image: File.new("#{Rails.root}/app/assets/images/people_category.jpg")
)

public_category = Category.create!(
  name: "Public"
)

public_category.photos << Photo.create!(
  image: File.new("#{Rails.root}/app/assets/images/public_category.png")
)

startup_category = Category.create!(
  name: "Startup"
)

startup_category.photos << Photo.create!(
  image: File.new("#{Rails.root}/app/assets/images/startup_category.jpg")
)

# projects
20.times do |n|
  project1 = Project.create!(
                  title: "Timmy's vaccine shots_#{n}",
                  price: 50000,
                  description: "These are malaria shots for little Timmy." * 3,
                  retired: false,
                  categories: [people_category],
                  tenant_id: Tenant.first.id,
                  repayment_rate: 28,
                  requested_by: Date.new(2015, 1, 1),
                  repayment_begin: Date.new(2015, 3, 30),
                  image_url: "https://s3.amazonaws.com/keevahh/timmys_vaccines.jpg"
                  )
  project1.photos << Photo.create!(
    image: File.new("#{Rails.root}/app/assets/images/timmys_vaccines.jpg")
    )

  project2 = Project.create!(
                  title: "Steven's school books_#{n}",
                  price: 4000,
                  description: "How can I teach deez kiiiids?" * 5,
                  retired: false,
                  categories: [startup_category],
                  tenant_id: Tenant.second.id,
                  repayment_rate: 28,
                  requested_by: Date.new(2015, 1, 1),
                  repayment_begin: Date.new(2015, 3, 30),
                  image_url: "https://s3.amazonaws.com/keevahh/school_children.jpg"
                  )
  project2.photos << Photo.create!(
    image: File.new("#{Rails.root}/app/assets/images/school_children.jpg")
    )

  project3 = Project.create!(
                  title: "John's water supply for village_#{n}",
                  price: 9000,
                  description: "We need water for our village of people." * 3,
                  retired: false,
                  categories: [public_category],
                  tenant_id: Tenant.third.id,
                  repayment_rate: 28,
                  requested_by: Date.new(2015, 1, 1),
                  repayment_begin: Date.new(2015, 3, 30),
                  image_url: "https://s3.amazonaws.com/keevahh/water_tower.jpg"
                  )
  project3.photos << Photo.create!(
    image: File.new("#{Rails.root}/app/assets/images/water_tower.jpg")
    )

  project4 = Project.create!(
                  title: "De Beers_#{n}",
                  price: 16000,
                  description: "Conflict diamonds are forever" * 5,
                  retired: false,
                  categories: [env_category],
                  tenant_id: Tenant.fourth.id,
                  repayment_rate: 28,
                  requested_by: Date.new(2015, 1, 1),
                  repayment_begin: Date.new(2015, 3, 30),
                  image_url: "https://s3.amazonaws.com/keevahh/environment.jpg"
                  )
  project4.photos << Photo.create!(
    image: File.new("#{Rails.root}/app/assets/images/environment.jpg")
    )

  Tenant.all[4..9].each do |tenant|
    project5 = Project.create!(
                    title: "Micro_Diamonds_#{tenant.id}_#{n}",
                    price: 16000,
                    description: "Conflict diamonds are forever" * 5,
                    retired: false,
                    categories: [env_category],
                    tenant_id: tenant.id,
                    repayment_rate: 28,
                    requested_by: Date.new(2015, 1, 1),
                    repayment_begin: Date.new(2015, 3, 30),
                    image_url: "https://s3.amazonaws.com/keevahh/debeers_diamonds.jpg"
                    )
    project5.photos << Photo.create!(
      image: File.new("#{Rails.root}/app/assets/images/debeers_diamonds.jpg")
      )
  end
end

# Orders with projects
4.times do |x|
  project = Project.find(x + 1)
  order =  Order.create!(
                        user_id: lender.id,
                        status:  "ordered",
                        loans:   []
                        )
  loan = Loan.create!(project_id: project.id, amount: 2500, order_id: order.id)
  order.loans << loan
end
