# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ItemOrder.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

# admin users
@admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                          city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)

# merchants or merchant shops - the shops that sell items for users to buy
@mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80201)
@meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
@j = Merchant.create(name: "J's Furniture Shop", address: '147 Bike Rd.', city: 'Denver', state: 'CO', zip: 80206)

#regular users - users with different roles
@regular_user = User.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
                                                    city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
@regular_user2 = User.create(name: "Moe",street_address: "1356 Lacienaga Ct. Denver, CO",
                                                    city: "denver",state: "CO",zip: "80305",email: "new_email2@gmail.com",password: "hamburger1", role: 1)
@regular_user3 = User.create(name: "Ben", street_address: "891 Penn St. Denver, CO",
city: "denver",state: "CO",zip: "80206",email: "merchant@gmail.com",password: "hamburger2", role: 2)

# merchant items - the items linked to each of the shops above
@tire = @meg.items.create(name: "Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
@shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
@paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
@yellow_pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
@chain = @j.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)


# orders - users and their information (tells you which user is ordering and the status of the order)
@order_1 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 0)
@order_2 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 1)
@order_3 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 2)
@order_4 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 2)
@order_5 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 3)
@order_6 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 0)
@order_7 = @regular_user3.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 3)

# item_orders - link the order with an item (user info and the item linked to a shop)
@item_order1 = ItemOrder.create!(item: @tire, order: @order_1, price: @tire.price, quantity: 7)
@item_order2 = ItemOrder.create!(item: @paper, order: @order_2, price: @paper.price, quantity: 4)
@item_order3 = ItemOrder.create!(item: @yellow_pencil, order: @order_3, price: @yellow_pencil.price, quantity: 10)
@item_order4 = ItemOrder.create!(item: @tire, order: @order_4, price: @tire.price, quantity: 2)
@item_order5 = ItemOrder.create!(item: @paper, order: @order_5, price: @paper.price, quantity: 15)
@item_order6 = ItemOrder.create!(item: @yellow_pencil, order: @order_6, price: @yellow_pencil.price, quantity: 40)
@item_order7 = ItemOrder.create!(item: @tire, order: @order_1, price: @tire.price, quantity: 7)
@item_order8 = ItemOrder.create!(item: @chain, order: @order_7, price: @chain.price, quantity: 10)
@item_order9 = ItemOrder.create!(item: @shifter, order: @order_4, price: @shifter.price, quantity: 10)
@item_order10 = ItemOrder.create!(item: @shifter, order: @order_7, price: @shifter.price, quantity: 10)
