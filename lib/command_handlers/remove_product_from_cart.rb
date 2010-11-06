module CommandHandlers::RemoveProductFromCart
  def handle_remove_product_from_cart(command)
    cart = repository.find(command.cart_id)
    cart.remove_product(command.product_id, command.price)
    repository.save(cart)
  end
end