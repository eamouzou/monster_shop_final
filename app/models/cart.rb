class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id, quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id, quantity|
      Item.find(item_id).price * quantity
    end
  end

  def discount_subtotal(item, quantity)
    discount = relevant_discounts(item, quantity).max_by {|discount| discount.threshold}
    item.update_discount_id(discount)
    ((item.price * (100 - discount.percentage) / 100.to_f) * quantity).round(2)
  end

  def relevant_discounts(item, quantity)
    Discount.all.find_all do |discount|
      discount.merchant == item.merchant && quantity >= discount.threshold
    end
  end

  def discount_total_eligible?
    @contents.any? do |item_id, quantity|
      Discount.all.any? do |discount|
        discount.merchant == Item.find(item_id).merchant
      end
    end
  end

  def discount_total
    @contents.sum do |item_id, quantity|
      item = Item.find(item_id)
      if item.discount_apply?(quantity)
        discount_subtotal(item, quantity)
      else
        item.price * quantity
      end
    end
  end

end
