module CommandHandlers::RemoveProductFromOrder
  def handle_remove_product_from_order(command)
    order = repository.find(command.order_id)
    order.remove_product(command.product_id, command.price)
    repository.save(order)
  end
end