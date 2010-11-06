module CommandHandlers::ClearCart
  def handle_clear_cart(command)
    cart = repository.find(command.cart_id)
    cart.clear
    repository.save(cart)
  end
end