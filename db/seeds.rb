john = User.create(username: 'user',password: 'password', first_name: 'John', last_name: 'Doe', display_name: "MikeDaoSellsCelluliteProducts", email: 'example@example.com', role: 1)

coffee = Category.create(name: 'Coffee', image: "fa fa-coffee")
brewing = Category.create(name: 'Brewing', image: "fa fa-tint")
merchandise = Category.create(name: 'Merchandise', image: "fa fa-gratipay")
chow = Category.create(name: 'Chow', image: "fa fa-cutlery")
shop_all = Category.create(name: 'Shop All', image: "fa fa-archive")

item1 = coffee.items.create!(title: 'Non-fat latte with caramel drizzle', description: 'For the skinny but caffeinated', price: 1000, photo: 'http://i.huffpost.com/gen/1270227/thumbs/o-COFFEE-570.jpg?5')
item2 = coffee.items.create!(title: 'Grande iced sugar-free vanilla latte with soy milk', description: 'For the healthy organic individual', price: 800, photo: 'http://i.huffpost.com/gen/1269829/thumbs/o-COFFEE-570.jpg?1')
item3 = coffee.items.create!(title: 'Triple venti soy low-foam latte', description: 'Bring out the indulgent European in you', price: 1200, photo: 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQA9Sn_r7xu2Y6NcHd88xGYQmYMlgaBiTv41H7US2bZ4ZloyvN1')
item4 = coffee.items.create!(title: 'Non-fat frappuccino with extra whip cream and chocolate', description: 'YOLO', price: 1500, photo: 'https://s-media-cache-ak0.pinimg.com/236x/c3/b8/fb/c3b8fbaf949af7b2de462c329dc3a5be.jpg')

item5 = brewing.items.create!(title: 'Coffee Press', description: 'For freshly pressed coffee', price: 2000, photo: 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcQ5NlGcy_F84fBcae-ALQ7iKGfs5XUO_HgUqLc0XJ9MD1m01bqrtDc87005-hua-mcNUvMS3DSm&usqp=CAE')
item6 = brewing.items.create!(title: 'Coffee Grinder', description: 'When you need to grind your own black powder from colombian beans', price: 100000, photo: 'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcQZtD9JD5b3_39MasTPVTvXaygBBHz57FH0MTXn0o3dKSfMsvuJQAq7f4KspSnzXAu4cGetba7C&usqp=CAE')

item7 = merchandise.items.create!(title: 'Coffee Cup Toilet', description: 'What is the coffee sludge at the bottom of your cup?', price: 2000, photo: 'http://i00.i.aliimg.com/wsphoto/v0/1149350762_1/Free-shipping-Unique-Gift-Novelty-Items-Icecream-font-b-Pot-b-font-Coffee-font-b-Cup.jpg')
