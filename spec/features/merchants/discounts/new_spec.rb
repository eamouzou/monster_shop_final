require 'rails_helper'

RSpec.describe 'As an merchant employee', type: :feature do
  context 'I can add a discount' do
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
      click_link('Manage Discounts')
      expect(current_path).to eq("/merchant/#{@merchant_user.merchant.id}/discounts")
      click_link('Add New Discount')
      expect(current_path).to eq("/merchant/#{@merchant_user.merchant.id}/discounts/new")
    end

    it "adds discount" do
      name = "60% off 50 Items or More"
      percentage = 60
      threshold = 50

      fill_in :name, with: name
      fill_in :percentage, with: percentage
      fill_in :threshold, with: threshold

      click_button "Create Discount"

      new_discount = Discount.last

      expect(current_path).to eq("/merchant/#{@merchant_user.merchant.id}/discounts")
      expect(page).to have_css("#discount-#{new_discount.id}")
    end

    it "flashes error message if form filled out incorrectly" do
      name = nil
      percentage = "-45"
      threshold = 0

      fill_in :name, with: name
      fill_in :percentage, with: percentage
      fill_in :threshold, with: threshold

      click_button "Create Discount"
      
      expect(current_path).to eq("/merchant/#{@merchant_user.merchant.id}/discounts/new")
      expect(page).to have_content("Name can't be blank, Percentage must be greater than 0, and Threshold must be greater than 4")
    end

  end
end
