module CommandHandlers::RemoveCouponFromCart
  def handle_remove_coupon_from_cart(command)
    cart = repository.find(command.cart_id)
    cart.remove_coupon(command.code, command.discount)
    repository.save(cart)
  end
end