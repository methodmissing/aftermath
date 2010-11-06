module CommandHandlers::UpdateCartQuantity
  def handle_update_cart_quantity(command)
    cart = repository.find(command.cart_id)
    cart.update_quantity(command.product_id, command.price, command.quantity)
    repository.save(cart)
  end
end