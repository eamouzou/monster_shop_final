class Discount < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates_presence_of :percentage
  validates_numericality_of :percentage, greater_than: 0, less_than: 100

  belongs_to :merchant
  has_many :orders
end
