require 'rails_helper'

RSpec.describe 'As an merchant employee', type: :feature do
  context 'I can access the merchant dashboard' do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @twentyoff = @bike_shop.discounts.create(name: "20%off30ItemsOrMore", percentage: 20, threshold: 30)
      @fiveoff = @bike_shop.discounts.create(name: "5%off10ItemsOrMore", percentage: 5, threshold: 10)

      @tire = @bike_shop.items.create(name: "Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @shifter = @bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      @regular_user = @bike_shop.users.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
        city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)

      @merchant_user = @bike_shop.users.create!(name: "Ben", street_address: "891 Penn St. Denver, CO",
                                city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)
      @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                                city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)

      @order_1 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 0)
      @order_2 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 1)

      @order_discount1 = OrderDiscount.create(discount_id: @twentyoff.id, order_id: @order_1.id)
      @order_discount2 = OrderDiscount.create(discount_id: @fiveoff.id, order_id: @order_1.id)
      @order_discount3 = OrderDiscount.create(discount_id: @twentyoff.id, order_id: @order_2.id)
      @order_discount4 = OrderDiscount.create(discount_id: @fiveoff.id, order_id: @order_2.id)

      @item_order1 = ItemOrder.create!(item: @tire, order: @order_1, price: @tire.price, quantity: 7)
      @item_order2 = ItemOrder.create!(item: @shifter, order: @order_2, price: @shifter.price, quantity: 4)

      visit '/'
      click_link 'Login'
      expect(current_path).to eq('/login')

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'hamburger2'
      click_button 'Log In'

      expect(current_path).to eq('/merchant/dashboard')
    end

    it "can see the name and address of the merchant the user works for" do
      visit "/merchant/#{@merchant_user.id}/dashboard"
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
    end

    it "orders information with items I sell can be seen by & see a link to my items index" do
      click_link "Logout"

      mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      user = User.create(name: "Bert",
                        street_address: "123 Sesame St.",
                        city: "NYC",
                        state: "New York",
                        zip: 10001,
                        email: "bert@gmail.com",
                        password: "password1",
                        password_confirmation: "password1",
                        role: 1)


      click_link 'Login'
      expect(current_path).to eq('/login')

      fill_in :email, with: user.email
      fill_in :password, with: 'password1'
      click_button 'Log In'

      expect(current_path).to eq('/profile')

      visit "/items/#{tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in :name, with: user.name
      fill_in :address, with: user.street_address
      fill_in :city, with: user.city
      fill_in :state, with: user.state
      fill_in :zip, with: user.zip

      click_button "Create Order"

      new_order = Order.last
      click_link "Logout"
      click_link 'Login'
      expect(current_path).to eq('/login')

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'hamburger2'
      click_button 'Log In'
      visit "/merchant/#{@merchant_user.id}/dashboard"
      expect(page).to have_link(new_order.id)
      expect(page).to have_content(new_order.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content("Quantity of Items in Order: 1")
      expect(page).to have_content("Total Cost of Merchant Items: $100")

      click_link 'Our store items'

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it "can click link for discounts on dashboard" do
      expect(page).to have_link('Manage Discounts')
      click_link('Manage Discounts')
      
      expect(current_path).to eq("/merchant/#{@merchant_user.merchant.id}/discounts")
    end
  end
end
