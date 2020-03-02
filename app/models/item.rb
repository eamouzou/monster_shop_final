class Item < ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders
  belongs_to :discount, optional: true

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular
    joins(:item_orders)
    .select('items.* sum, sum(item_orders.quantity) as quantity')
    .group(:id)
    .order('quantity desc')
    .limit(5).to_a
  end

  def self.least_popular
    joins(:item_orders)
    .select('items.* sum, sum(item_orders.quantity) as quantity')
    .group(:id)
    .order('quantity')
    .limit(5).to_a
  end

  def updates_active
    if active? == true
      update(active?: false)
    else
      update(active?: true)
    end
  end

  def fulfill_item(order)
    orders = item_orders.where(order: order)
    orders.update_all(status: "fulfilled")
  end

  def update_inventory(order)
    item_order = order.item_orders.where(item: self)
    new_amount = inventory - item_order.first.quantity
    update(inventory: new_amount)
  end

  def discount_apply?(quantity)
    Discount.all.any? do |discount|
      discount.merchant == self.merchant && quantity >= discount.threshold
    end
  end

  def discount_price
    percent_off = discount.percentage / 100.to_f
    price * (1 - percent_off).round(2)
  end

  def update_discount_id(discount)
    update(discount_id: discount.id)
  end

end
