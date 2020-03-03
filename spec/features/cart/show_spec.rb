require 'rails_helper'

RSpec.describe 'Cart show', type: :feature do
  before(:each) do
    @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
    @paper = @print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    @items_in_cart = [@paper,@tire,@pencil]
  end

  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")

        click_on "Empty Cart"

        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'

        within "#cart-item-#{@paper.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        within "#cart-item-#{@tire.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        within "#cart-item-#{@pencil.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'

        within "#cart-item-#{@paper.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        within "#cart-item-#{@tire.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        within "#cart-item-#{@pencil.id}" do
          click_on '-'
          expect(current_path).to eq('/cart')
        end

        expect(page).to_not have_link("Empty Cart")
      end
    end
  end

  it "shows discounted items" do
    visit '/cart'
    @twentyoff = @bike_shop.discounts.create(name: "20%off30ItemsOrMore", percentage: 20, threshold: 30)
    @fiveoff = @bike_shop.discounts.create(name: "5%off10ItemsOrMore", percentage: 5, threshold: 10)

    @regular_user = @bike_shop.users.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
      city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)

    within "#cart-item-#{@tire.id}" do
      expect(page).to have_content("$100.00")

      9.times { click_on '+'}
      expect(page).to have_content("$1,000.00")
      expect(page).to have_content("$950.00")
      expect(page).to have_content("10")
      expect(page).to have_content("Discount Applied")

      20.times { click_on "+"}
      expect(page).to have_content("$3,000.00")
      expect(page).to have_content("$2,400.00")
      expect(page).to have_content("30")
      expect(page).to have_content("Discount Applied")
    end


    expect(page).to have_content("$3,022.00")
    expect(page).to have_content("Discount Applied")
    expect(page).to have_content("Total: $2,422.00")
  end


end
