module CommandHandlers::CreateOrder
  def handle_create_order(command)
    order = Aggregates::Order.new(:uuid => command.order_id,
                                  :user_id => command.user_id,
                                  :customer_name => command.customer_name,
                                  :status => command.status)
    repository.save(order, -1)
  end
end