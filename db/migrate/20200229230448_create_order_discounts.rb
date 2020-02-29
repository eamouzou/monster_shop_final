class CreateOrderDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :order_discounts do |t|
      t.references :discount, foreign_key: true
      t.references :order, foreign_key: true
    end
  end
end
