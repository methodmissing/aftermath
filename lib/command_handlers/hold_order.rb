module CommandHandlers::HoldOrder
  def handle_hold_order(command)
    order = repository.find(command.order_id)
    order.hold(command.reason)
    repository.save(order)
  end
end