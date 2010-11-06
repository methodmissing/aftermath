module CommandHandlers::CreateCart
  def handle_create_cart(command)
    cart = Aggregates::Cart.new(:uuid => command.cart_id)
    repository.save(cart, -1)
  end
end