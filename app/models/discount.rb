class Discount < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates_presence_of :percentage
  validates_numericality_of :percentage, greater_than: 0, less_than: 100
  validates_presence_of :threshold
  validates_numericality_of :threshold, greater_than: 4, less_than: 61

  belongs_to :merchant
  has_many :items
  has_many :order_discounts
  has_many :orders, through: :order_discounts

  def generate_order_discounts
    merchant.item_orders.pluck(:order_id).each do |order_id|
      OrderDiscount.create(discount_id: self.id, order_id: order_id)
    end
  end
end
