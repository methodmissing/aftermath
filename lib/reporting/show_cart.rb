class Reporting::ShowCart < Aftermath::Handler
  class Dto < Struct.new(:cart_id, :products, :coupons, :total)
  end

  def find(cart_id)
    repository[cart_id]
  end

  private
  def handle_cart_created(event)
    cart = Dto.new(event.cart_id, {}, {}, 0)
    repository[event.cart_id] = cart
  end

  def handle_cart_cleared(event)
    cart = find(event.cart_id)
    cart.products.clear
    cart.total = 0
  end

  def handle_cart_quantity_updated(event)
    cart = find(event.cart_id)
    cart.total += event.price
    cart.products[event.product_id][1] = event.quantity
  end

  def handle_product_added_to_cart(event)
    cart = find(event.cart_id)
    cart.total += event.price
    cart.products[event.product_id] = [event.product_name, event.quantity, event.unit_price]
  end

  def handle_product_removed_from_cart(event)
    cart = find(event.cart_id)
    cart.total -= event.price
    cart.products.delete(event.product_id)
  end
end