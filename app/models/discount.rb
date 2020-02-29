class Discount < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates_presence_of :percentage
  validates_numericality_of :percentage, greater_than: 0, less_than: 100
  validates_presence_of :threshold
  validates_numericality_of :threshold, greater_than: 4, less_than: 61

  belongs_to :merchant
  has_many :order_discounts
  has_many :orders, through: :order_discounts
end
