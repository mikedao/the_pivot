john = User.create(username: 'user',password: 'password', first_name: 'John', last_name: 'Doe', email: 'example@example.com', role: 1)

coffee = Category.create(name: 'Coffee', image: "fa fa-coffee")
brewing = Category.create(name: 'Brewing', image: "fa fa-tint")
merchandise = Category.create(name: 'Merchandise', image: "fa fa-gratipay")
chow = Category.create(name: 'Chow', image: "fa fa-cutlery")
shop_all = Category.create(name: 'Shop All', image: "fa fa-archive")

item1 = brewing.items.create!(title: 'Mexican Organic Dark Coffee', description: 'Bold smoky aroma with a smooth body and dark cocoa finish', price: 1200, photo: 'beans.png')
item2 = brewing.items.create!(title: 'Columbian Dark Coffee', description: 'Creamy and smooth-bodied with a smoky aroma and well-balanced flavor', price: 1500, photo: 'coffee.bag.jpg')

item3 = merchandise.items.create!(title: 'Clear Kit', description: 'Full Kit.', price: 8000, photo: 'merch.jpg')
item4 = merchandise.items.create!(title: 'Coffee Grinder', description: 'Classic hand crank coffee grinder', price: 2000, photo: 'grinder.jpg')
item5 = merchandise.items.create!(title: 'Espresso Machine', description: 'Bring out the indulgent European in you', price: 12000, photo: 'espresso-machine.jpg')
item6 = merchandise.items.create!(title: 'Coffee Maker', description: 'Chrome coffee maker, for the baller in you', price: 5000, photo: 'coffee-maker.jpg')

item7 = chow.items.create!(title: 'Artichoke Souffle', description: 'Try this rich-tasting cheese, artichoke and spinach soufflé recipe for your next brunch.', price: 700, photo: 'breakfast.jpg')
item8 = chow.items.create!(title: 'Berry Tart', description: 'Lightly sweetened berries top vanilla bean-flecked pastry cream contained in a graham cracker crust.', price: 500, photo: 'tarts.jpg')
item9 = chow.items.create!(title: 'Caprese Panini', description: 'The classic combination of mozzarella, tomatoes and basil is known as caprese.', price: 700, photo: 'panini.jpg')
item10 = chow.items.create!(title: 'Blueberry Muffin', description: 'blueberry muffins balance a moist, buttery crumb topping and are equally delicious with blueberries in season.', price: 400, photo: 'muffin.jpg')
item11 = chow.items.create!(title: 'Wedge Salad', description: 'Hearts of romaine lettuce, painted with a herb vinaigrette, and grilled.', price: 800, photo: 'salad.jpg')
item12 = chow.items.create!(title: 'Tomato Soup and Toasted Ravioli', description: 'Creamy tomatoe soup made from freash local ingrediants, garnished with our in house toasted ravioli pasta.', price: 800, photo: 'soup.jpg')

item13 = coffee.items.create!(title: 'Capuccino', description: 'Our Creamy cappuccino offers a stronger espresso flavor and a luxurious texture.', price: 500, photo: 'biscotti.jpg')
item14 = coffee.items.create!(title: 'Chocolate Capuccino', description: 'Chocolaty sweetness and hearty coffee unite to create a decadent cup of cappuccino.', price: 500, photo: 'choc-coffee.jpg')
item15 = coffee.items.create!(title: 'Cinnful Capuccino', description: 'An espresso and cinnamon-scented scone with cappuccino.', price: 500, photo: 'cinn-tea.png')
item16 = coffee.items.create!(title: 'Cocoa', description: 'delicious organic chocolate to be savoured as it is or combined with intriguing infusions.', price: 500, photo: 'coco.jpg')
item17 = coffee.items.create!(title: 'Latte', description: 'A shot of strong espresso coffee, with a healthy covering of hot steamed milk and a topping of steamed milk froth served in a glass.', price: 500, photo: 'latte.jpg')
item18 = coffee.items.create!(title: 'Green Tea', description: 'Green tea potential health benefits for everything from fighting cancer to helping your heart, and it taste pretty okay too.', price: 500, photo: 'green-tea.jpg')
