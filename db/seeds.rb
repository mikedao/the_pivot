# Users
User.create!(
  username:              "D`Cathy",
  first_name:            "Dan",
  last_name:             "Cathy",
  email:                 "DanCathy@gmail.com",
  password:              "password",
  password_confirmation: "password",
  city:                  "Atlanta",
  state:                 "GA",
  street:                "5200 Buffington Road",
  zipcode:               30349,
  country:               "USA",
  credit_card_info:      "1111222233334444"
)

5.times do |n|
  username =                Faker::Internet.user_name
  first_name =              Faker::Name.first_name
  last_name =               Faker::Name.last_name
  country =                 Faker::Address.country
  email =                   "FlowersNPuppies-#{n + 1}@gmail.com"
  password =                "password"
  credit_card_info =        "11112222333#{n + 1}44#{n + 2}4"
  street =                  "6#{n + 1}#{n + 2} Mockingbird Lane"
  User.create!(
    username:               username,
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

puts "#{User.count} users created."

ronald1 = User.find(2)
ronald2 = User.find(3)
ronald3 = User.find(4)
ronald4 = User.find(5)

# tenants
# bridge_builders = Tenant.create!(
#   location:              "East Timor represent",
#   organization:          "Bridge Builders"
# )

4.times do |n|
  location =              "East Timor represent#{n + 1}"
  organization =          "Bridge Builders#{n + 1}"
  Tenant.create!(
    location:             location,
    organization:         organization
  )
end

bridge_builders1 = Tenant.find(1)
bridge_builders2 = Tenant.find(2)
bridge_builders3 = Tenant.find(3)

# admin
Admin.create!(
        username: "FlowersNPuppies",
        password: "password",
        email:    "FlowersNPuppies.@gmail.com"
      )

# categories
people_category = Category.create!(
  name: "People"
)

public_category = Category.create!(
  name: "Public"
)

startup_category = Category.create!(
  name: "Startup"
)

conflict_zone_category = Category.create!(
  name: "Conflict Zones"
)

# projects
timmys_vaccines_nigeria = Project.create!(
                  title: "Timmy's vaccine shots",
                  price: 50000,
                  description: "These are malaria shots for little Timmy." * 3,
                  retired: false,
                  categories: [people_category],
                  tenant_id: bridge_builders1.id
                  )

stevens_books_bangkok = Project.create!(
                  title: "Steven's school books",
                  price: 4000,
                  description: "How can I teach deez kiiiids?" * 5,
                  retired: false,
                  categories: [startup_category],
                  tenant_id: bridge_builders1.id
                  )

johns_waterworks_cotedivore = Project.create!(
                  title: "John's water supply for village",
                  price: 9000,
                  description: "We need water for our village of people." * 3,
                  retired: false,
                  categories: [public_category],
                  tenant_id: bridge_builders2.id
                  )

debeers_conflict_diamonds_ivorycoast = Project.create!(
                  title: "De Beers",
                  price: 16000,
                  description: "Conflict diamonds are forever" * 5,
                  retired: false,
                  categories: [conflict_zone_category],
                  tenant_id: bridge_builders3.id
                  )

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
