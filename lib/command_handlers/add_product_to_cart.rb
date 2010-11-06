module CommandHandlers::AddProductToCart
  def handle_add_product_to_cart(command)
    cart = repository.find(command.cart_id)
    cart.add_product(command.product_id, command.product_name, command.price, command.quantity)
    repository.save(cart)
  end
end