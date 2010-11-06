class Reporting::ListOrders < Aftermath::Handler
  class Dto < Struct.new(:order_id, :user_id, :customer_name, :total, :status)
  end

  def list
    repository
  end

  private
  def find(uuid)
    repository.find{|r| r.order_id == uuid }
  end

  def handle_order_created(event)
    repository << Dto.new(event.order_id, event.user_id, event.customer_name, 0, event.status)
  end

  def handle_order_quantity_updated(event)
    order = find(event.order_id)
    order.total += event.price
  end

  def handle_order_cancelled(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def handle_order_held(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def handle_order_shipped(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def handle_product_added_to_order(event)
    order = find(event.order_id)
    order.total += event.price
  end

  def handle_product_removed_from_order(event)
    order = find(event.order_id)
    order.total -= event.price
  end
end