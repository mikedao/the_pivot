# lenders
100.times do |n|
  first_name =              Faker::Name.first_name
  last_name =               Faker::Name.last_name
  country =                 Faker::Address.country
  email =                   "FlowersNPuppies-#{n + 1}@gmail.com"
  password =                "password"
  credit_card_info =        "11112222333#{n + 1}44#{n + 2}4"
  street =                  "6#{n + 1}#{n + 2} Mockingbird Lane"
  User.create!(
    username:               "lender#{n}",
    email:                  email,
    password:               password,
    password_confirmation:  password,
    first_name:             first_name,
    last_name:              last_name,
    city:                   "Atlanta",
    state:                  "GA",
    zipcode:                50240,
    street:                 street,
    country:                country,
    credit_card_info:       credit_card_info
  )
end

# tenants
10.times do |n|
  location =              "East Timor represent#{n + 1}"
  organization =          "Bridge Builders#{n + 1}"
  Tenant.create!(
    location:             location,
    organization:         organization
  )
end

# admin
Admin.create!(
  username: "admin",
  password: "password",
  email: "admin@admin.com"
)

# borrowers
User.create!(
username:              "borrower",
first_name:            "Jorge",
last_name:             "Telez",
email:                 "example@example.com",
password:              "password",
password_confirmation: "password",
city:                  "Atlanta",
state:                 "GA",
street:                "5200 Buffington Road",
zipcode:               30349,
country:               "USA",
credit_card_info:      "1111222233334444",
tenant_id:             Tenant.find(1)
)

Tenant.all.each do |tenant|
  2.times do |n|
    User.create!(
    username:              "borrower_#{tenant_id}_#{n}",
    first_name:            "Jorge",
    last_name:             "Telez",
    email:                 "example@example.com",
    password:              "password",
    password_confirmation: "password",
    city:                  "Atlanta",
    state:                 "GA",
    street:                "5200 Buffington Road",
    zipcode:               30349,
    country:               "USA",
    credit_card_info:      "1111222233334444",
    tenant_id:             Tenant.find(1)
    )
  end
end

# categories
people_category = Category.create!(
  name: "People"
)

env_category = Category.create!(
  name: "Environment"
)

startup_category = Category.create!(
  name: "Startup"
)

conflict_zone_category = Category.create!(
  name: "Conflict Zones"
)

animals_category = Category.create!(
name: "Animals"
)

# projects
Tenant.all.each do |tenant|
  Project.create!(
                  title: "Timmy's vaccine shots_#{tenant_id}",
                  price: 50000,
                  description: "These are malaria shots for little Timmy." * 3,
                  retired: false,
                  categories: [people_category],
                  tenant_id: tenant.id
                  )

  Project.create!(
                  title: "Steven's school books_#{tenant_id}",
                  price: 4000,
                  description: "How can I teach deez kiiiids?" * 5,
                  retired: false,
                  categories: [startup_category, conflict_zone_category],
                  tenant_id: tenant.id
                  )

  Project.create!(
                  title: "John's water supply for village_#{tenant_id}",
                  price: 9000,
                  description: "We need water for our village of people." * 3,
                  retired: false,
                  categories: [public_category],
                  tenant_id: tenant.id
                  )

  Project.create!(
                  title: "De Beers",
                  price: 16000,
                  description: "Conflict diamonds are forever_#{tenant_id}" * 5,
                  retired: false,
                  categories: [conflict_zone_category],
                  tenant_id: tenant.id
                  )
end

# Orders with projects
timmys_vaccines_nigeria.orders.create!(
                  total_cost: timmys_vaccines_nigeria.price,
                  user_id:    ronald1.id,
                  status:     "ordered"
                  )

stevens_books_bangkok.orders.create!(
                  total_cost: stevens_books_bangkok.price,
                  user_id:    ronald2.id,
                  status:     "ordered"
                  )

johns_waterworks_cotedivore.orders.create!(
                  total_cost: johns_waterworks_cotedivore.price,
                  user_id:    ronald3.id,
                  status:     "completed"
                  )

debeers_conflict_diamonds_ivorycoast.orders.create!(
                  total_cost: debeers_conflict_diamonds_ivorycoast.price,
                  user_id:    ronald4.id,
                  status:     "ordered"
                  )
