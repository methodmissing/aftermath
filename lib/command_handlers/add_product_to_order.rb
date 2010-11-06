module CommandHandlers::AddProductToOrder
  def handle_add_product_to_order(command)
    order = repository.find(command.order_id)
    order.add_product(command.product_id, command.product_name, command.price, command.quantity)
    repository.save(order)
  end
end