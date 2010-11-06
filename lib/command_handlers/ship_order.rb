module CommandHandlers::ShipOrder
  def handle_ship_order(command)
    order = repository.find(command.order_id)
    order.ship(command.comments)
    repository.save(order)
  end
end