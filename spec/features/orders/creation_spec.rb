require 'rails_helper'

RSpec.describe "Order Creation", type: :feature do
  describe "When I check out from my cart" do
    before(:each) do
      User.destroy_all
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user = User.create(name: "Bert",
                        street_address: "123 Sesame St.",
                        city: "NYC",
                        state: "New York",
                        zip: 10001,
                        email: "bert2@gmail.com",
                        password: "password1",
                        password_confirmation: "password1",
                        role: 1)

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: "password1"

      click_on "Log In"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      fill_in :name, with: @user.name
      fill_in :address, with: @user.street_address
      fill_in :city, with: @user.city
      fill_in :state, with: @user.state
      fill_in :zip, with: @user.zip

      click_button "Create Order"
      new_order = Order.last

      expect(current_path).to eq("/profile/orders")
      visit "/orders/#{new_order.id}"

      within '.shipping-address' do
        expect(page).to have_content(new_order.name)
        expect(page).to have_content(new_order.address)
        expect(page).to have_content(new_order.city)
        expect(page).to have_content(new_order.state)
        expect(page).to have_content(new_order.zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at)
      end
    end

    it 'i cant create order if info not filled out' do
      user = User.create!(name: "Bert",
                        street_address: "123 Turing St.",
                        city: "NYC",
                        state: "New York",
                        zip: 10001,
                        email: "bert@gmail.com",
                        password: "password1",
                        password_confirmation: "password1",
                        role: 1)

      fill_in :name, with: user.name
      fill_in :address, with: ""
      fill_in :city, with: user.city
      fill_in :state, with: user.state
      fill_in :zip, with: user.zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end

  describe "inactive items in order" do
    before :each do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user = User.create(name: "Bert",
                        street_address: "123 Sesame St.",
                        city: "NYC",
                        state: "New York",
                        zip: 10001,
                        email: "bert2@gmail.com",
                        password: "password1",
                        password_confirmation: "password1",
                        role: 0)

      visit '/login'
      fill_in :email, with: @user.email
      fill_in :password, with: "password1"
      click_on "Log In"
    end

    it "cant create order if an item is inactive" do
      @tire.update(active?: false)

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      expect(current_path).to eq("/items/#{@tire.id}")
      expect(page).to have_content("This item is inactive")
    end
  end

  describe "discounts on an order" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @twentyoff = @bike_shop.discounts.create(name: "20%off30ItemsOrMore", percentage: 20, threshold: 30)
      @fiveoff = @bike_shop.discounts.create(name: "5%off10ItemsOrMore", percentage: 5, threshold: 10)

      @tire = @bike_shop.items.create(name: "Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 60)
      @shifter = @bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 30)

      @regular_user = @bike_shop.users.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
        city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)

      @merchant_user = @bike_shop.users.create!(name: "Ben", street_address: "891 Penn St. Denver, CO",
                                city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)

      visit '/'
      click_link 'Login'
      fill_in :email, with: @regular_user.email
      fill_in :password, with: @regular_user.password
      click_button 'Log In'
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@shifter.id}"
      @shifter.update(active?: true)
      click_on "Add To Cart"
      visit '/cart'
      within "#cart-item-#{@tire.id}" do
        35.times { click_on '+'}
      end
      within "#cart-item-#{@shifter.id}" do
        15.times { click_on '+'}
      end
    end

    scenario "order is created with discounted prices" do
      visit "/cart"

      expect(page).to have_content("Total: $5,616.00")

      click_on "Checkout"

      expect(page).to have_content("Total: $5,616.00")

      fill_in :name, with: @regular_user.name
      fill_in :address, with: @regular_user.street_address
      fill_in :city, with: @regular_user.city
      fill_in :state, with: @regular_user.state
      fill_in :zip, with: @regular_user.zip

      click_button "Create Order"
      new_order = Order.last

      visit "/orders/#{new_order.id}"
      expect(page).to have_content("Total: $5,616.00")
    end
  end

end
