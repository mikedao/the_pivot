rachel = User.create(username: 'rachel',password: 'password', first_name: 'Rachel', last_name: 'Warbelow', email: "demo+rachel@jumpstartlab.com", role: 0)
jeff = User.create(username: 'j3',password: 'password', first_name: 'Jeff', last_name: 'Casimir', email: 'demo+jeff@jumpstartlab.com', role: 0)
jorge = User.create(username: 'novohispano',password: 'password', first_name: 'Jorge', last_name: 'Tellez', email: 'demo+jorge@jumpstartlab.com', role: 0)
josh = User.create(username: 'josh',password: 'password', first_name: 'Josh', last_name: 'Cheek', email: 'demo+josh@jumpstartlab.com', role: 1)

puts "#{User.count} users created."
coffee = Category.create(name: 'Coffee', image: "fa fa-coffee")
brewing = Category.create(name: 'Brewing', image: "fa fa-tint")
merchandise = Category.create(name: 'Merchandise', image: "fa fa-gratipay")
chow = Category.create(name: 'Chow', image: "fa fa-cutlery")
shop_all = Category.create(name: 'Shop All', image: "fa fa-archive")

item1 = brewing.items.create!(title: 'Mexican Organic Dark Coffee', description: 'Bold smoky aroma with a smooth body and dark cocoa finish.', price: 1200, image: File.new("#{Rails.root}/app/assets/images/beans.png"))
item2 = brewing.items.create!(title: 'Columbian Dark Coffee', description: 'Creamy and smooth-bodied with a smoky aroma and well-balanced flavor.', price: 1500, image: File.new("#{Rails.root}/app/assets/images/coffee.bag.jpg"))

item3 = merchandise.items.create!(title: 'Clear Kit', description: 'Full Kit.', price: 8000, image: File.new("#{Rails.root}/app/assets/images/merch.jpg"))
item4 = merchandise.items.create!(title: 'Coffee Grinder', description: 'Classic hand crank coffee grinder.', price: 2000, image: File.new("#{Rails.root}/app/assets/images/grinder.jpg"))
item5 = merchandise.items.create!(title: 'Espresso Machine', description: 'Bring out the indulgent European in you.', price: 12000, image: File.new("#{Rails.root}/app/assets/images/espresso-machine.jpg"))
item6 = merchandise.items.create!(title: 'Coffee Maker', description: 'Chrome coffee maker, for the baller in you.', price: 5000, image: File.new("#{Rails.root}/app/assets/images/coffee-maker.jpg"))

item7 = chow.items.create!(title: 'Artichoke Souffle', description: 'Try this rich-tasting cheese, artichoke and spinach soufflé recipe for your next brunch.', price: 700, image: File.new("#{Rails.root}/app/assets/images/breakfast.jpg"))
item8 = chow.items.create!(title: 'Berry Tart', description: 'Lightly sweetened berries top vanilla bean-flecked pastry cream contained in a graham cracker crust.', price: 500, image: File.new("#{Rails.root}/app/assets/images/tarts.jpg"))
item9 = chow.items.create!(title: 'Caprese Panini', description: 'The classic combination of mozzarella, tomatoes and basil is known as caprese.', price: 700, image: File.new("#{Rails.root}/app/assets/images/panini.jpg"))
item10 = chow.items.create!(title: 'Blueberry Muffin', description: 'Blueberry muffins balance a moist, buttery crumb topping and are equally delicious with blueberries in season.', price: 400, image: File.new("#{Rails.root}/app/assets/images/muffin.jpg"))
item11 = chow.items.create!(title: 'Wedge Salad', description: 'Hearts of romaine lettuce, painted with a herb vinaigrette, and grilled.', price: 800, image: File.new("#{Rails.root}/app/assets/images/salad.jpg"))
item12 = chow.items.create!(title: 'Tomato Soup and Toasted Ravioli', description: 'Creamy tomatoe soup made from freash local ingrediants, garnished with our in house toasted ravioli pasta.', price: 800, image: File.new("#{Rails.root}/app/assets/images/soup.jpg"))

item13 = coffee.items.create!(title: 'Capuccino', description: 'Our Creamy cappuccino offers a stronger espresso flavor and a luxurious texture.', price: 500, image: File.new("#{Rails.root}/app/assets/images/biscotti.jpg"))
item14 = coffee.items.create!(title: 'Chocolate Capuccino', description: 'Chocolaty sweetness and hearty coffee unite to create a decadent cup of cappuccino.', price: 500, image: File.new("#{Rails.root}/app/assets/images/choc-coffee.jpg"))
item15 = coffee.items.create!(title: 'Cinnful Capuccino', description: 'An espresso and cinnamon-scented scone with cappuccino.', price: 500, image: File.new("#{Rails.root}/app/assets/images/cinn-tea.png"))
item16 = coffee.items.create!(title: 'Cocoa', description: 'Delicious organic chocolate to be savoured as it is or combined with intriguing infusions.', price: 500, image: File.new("#{Rails.root}/app/assets/images/coco.jpg"))
item17 = coffee.items.create!(title: 'Latte', description: 'A shot of strong espresso coffee, with a healthy covering of hot steamed milk and a topping of steamed milk froth served in a glass.', price: 500, image: File.new("#{Rails.root}/app/assets/images/latte.jpg"))
item18 = coffee.items.create!(title: 'Green Tea', description: 'Green tea potential health benefits for everything from fighting cancer to helping your heart, and it taste pretty okay too.', price: 500, image: File.new("#{Rails.root}/app/assets/images/green-tea.jpg"))


jeff_order_1 = item1.orders.create(total_cost: item1.price, user_id: jeff.id, status: 'completed')
jeff_order_1.item_orders.last.update(quantity: 10, line_item_cost: item1.price)

jeff_order_2 = item3.orders.create(total_cost: item3.price, user_id: jeff.id, status: 'ordered')
jeff_order_2.item_orders.last.update(quantity: 11, line_item_cost: item3.price)

jeff_order_3 = item7.orders.create(total_cost: item7.price, user_id: jeff.id, status: 'cancelled')
jeff_order_3.item_orders.last.update(quantity: 15, line_item_cost: item7.price)

jeff_order_4 = item10.orders.create(total_cost: item10.price, user_id: jeff.id, status: 'paid')
jeff_order_4.item_orders.last.update(quantity: 19, line_item_cost: item10.price)

rachel_order_1 = item2.orders.create(total_cost: item2.price, user_id: rachel.id, status: 'completed')
rachel_order_1.item_orders.last.update(quantity: 4, line_item_cost: item2.price)

rachel_order_2 = item11.orders.create(total_cost: item11.price, user_id: rachel.id, status: 'ordered')
rachel_order_2.item_orders.last.update(quantity: 6, line_item_cost: item11.price)

jorge_order_1 = item16.orders.create(total_cost: item16.price, user_id: jorge.id, status: 'cancelled')
jorge_order_1.item_orders.last.update(quantity: 7, line_item_cost: item16.price)

jorge_order_2 = item11.orders.create(total_cost: item11.price, user_id: jorge.id, status: 'cancelled')
jorge_order_2.item_orders.last.update(quantity: 2, line_item_cost: item11.price)

josh_order_1 = item16.orders.create(total_cost: item5.price, user_id: josh.id, status: 'paid')
josh_order_1.item_orders.last.update(quantity: 12, line_item_cost: item5.price)

josh_order_2 = item11.orders.create(total_cost: item17.price, user_id: josh.id, status: 'completed')
josh_order_2.item_orders.last.update(quantity: 1, line_item_cost: item17.price)
