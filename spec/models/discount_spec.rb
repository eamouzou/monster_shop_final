require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_numericality_of(:percentage).is_less_than(100)}
    it { should validate_numericality_of(:percentage).is_greater_than(0)}
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of(:threshold).is_less_than(61)}
    it { should validate_numericality_of(:threshold).is_greater_than(4)}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many(:orders).through(:order_discounts)}
    it {should have_many :order_discounts}
    it {should have_many :items}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @twentyoff = @bike_shop.discounts.create(name: "20%off30ItemsOrMore", percentage: 20, threshold: 30)
      @tire = @bike_shop.items.create(name: "Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 40)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @regular_user = @bike_shop.users.create(name: "Mike",street_address: "456 Logan St. Denver, CO", city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
      @order_1 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 0)
      @order_2 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 1)
      @item_order1 = ItemOrder.create!(item: @tire, order: @order_1, price: @tire.price, quantity: 7)
      @item_order2 = ItemOrder.create!(item: @chain, order: @order_2, price: @chain.price, quantity: 4)
    end

    it ".generate_order_discounts" do
      expect(OrderDiscount.all.empty?).to eq(true)
      @twentyoff.generate_order_discounts
      expect(OrderDiscount.all.empty?).to eq(false)
    end
  end
end
