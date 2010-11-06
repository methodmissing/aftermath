module CommandHandlers::CancelOrder
  def handle_cancel_order(command)
    order = repository.find(command.order_id)
    order.cancel(command.reason)
    repository.save(order)
  end
end