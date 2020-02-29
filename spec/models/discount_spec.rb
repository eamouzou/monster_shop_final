require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_uniqueness_of :name }
    it { should validate_numericality_of(:percentage).is_less_than(100)}
    it { should validate_numericality_of(:percentage).is_greater_than(0)}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many(:orders)}
  end
end
