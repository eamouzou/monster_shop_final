require 'rails_helper'

RSpec.describe OrderDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :discount_id }
    it { should validate_presence_of :order_id }
  end

  describe "relationships" do
    it {should belong_to :discount}
    it {should belong_to :order}
  end
end
