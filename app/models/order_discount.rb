class OrderDiscount < ApplicationRecord
  validates_presence_of :discount_id, :order_id

  belongs_to :discount
  belongs_to :order
end
