class Aggregates::Cart < Aftermath::Aggregate
  property :products
  property :coupons
  property :total

  def initialize(data = nil)
    apply Event(:CartCreated, :cart_id => data[:uuid]) if data
  end

  def add_product(product_id, product_name, price, quantity)
    delta = quantity * price
    apply Event(:ProductAddedToCart, :cart_id => uuid,
                                     :product_id => product_id,
                                     :product_name => product_name,
                                     :unit_price => price,
                                     :cart_total => @total + delta,
                                     :quantity => quantity)
  end

  def remove_product(product_id, price)
    delta = (@products[product_id] * price)
    apply Event(:ProductRemovedFromCart, :cart_id => uuid,
                                         :product_id => product_id,
                                         :unit_price => price,
                                         :cart_total => @total - delta)
  end

  def update_quantity(product_id, price, quantity)
    delta = (@products[product_id] - quantity) * price
    apply Event(:CartQuantityUpdated, :cart_id => uuid, 
                                      :product_id => product_id,
                                      :unit_price => price,
                                      :cart_total => @total + delta,
                                      :quantity => quantity)
  end

  def clear
    apply Event(:CartCleared, :cart_id => uuid)
  end

  def add_coupon(code, discount)
    delta = @total - discount
    apply Event(:CouponAdded, :cart_id => uuid, :code => code, :discount => discount, :cart_total => delta)
  end

  def remove_coupon(code, discount)
    delta = @total + discount
    apply Event(:CouponRemoved, :cart_id => uuid, :code => code, :discount => discount, :cart_total => delta)
  end

  private
  def apply_cart_created(event)
    @uuid = event.cart_id
    @products = {}
    @coupons = {}
    @total = 0
  end

  def apply_product_added_to_cart(event)
    @products[event.product_id] = event.quantity
    @total = event.cart_total
  end

  def apply_product_removed_from_cart(event)
    @products.delete(event.product_id)
    @total = event.cart_total
  end

  def apply_cart_quantity_updated(event)
    @products[event.product_id] = event.quantity
    @total = event.cart_total
  end

  def apply_cart_cleared(event)
    @products = {}
    @coupons = {}
    @total = 0
  end

  def apply_coupon_added(event)
    @coupons[event.code] = event.discount
    @total = event.cart_total
  end

  def apply_coupon_removed(event)
    @coupons.delete(event.code)
    @total = event.cart_total
  end
end