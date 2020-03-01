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
end
