module CommandHandlers::AddCouponToCart
  def handle_add_coupon_to_cart(command)
    cart = repository.find(command.cart_id)
    cart.add_coupon(command.code, command.discount)
    repository.save(cart)
  end
end