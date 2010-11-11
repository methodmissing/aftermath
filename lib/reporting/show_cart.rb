class Reporting::ShowCart < Aftermath::View
  class Dto < Struct.new(:cart_id, :products, :coupons, :total)
  end

  private
  def self.handle_cart_created(event)
    cart = Dto.new(event.cart_id, {}, {}, 0)
    repository[event.cart_id] = cart
  end

  def self.handle_cart_cleared(event)
    cart = find(event.cart_id)
    cart.products.clear
    cart.total = 0
  end

  def self.handle_cart_quantity_updated(event)
    cart = find(event.cart_id)
    cart.total = event.cart_total
    cart.products[event.product_id][1] = event.quantity
  end

  def self.handle_product_added_to_cart(event)
    cart = find(event.cart_id)
    cart.total = event.cart_total
    cart.products[event.product_id] = [event.product_name, event.quantity, event.unit_price]
  end

  def self.handle_product_removed_from_cart(event)
    cart = find(event.cart_id)
    cart.total = event.cart_total
    cart.products.delete(event.product_id)
  end
end