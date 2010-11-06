class Reporting::OrderDetails < Aftermath::Handler
  class Dto < Struct.new(:order_id, :user_id, :customer_name, :products, :total, :status, :comments)
  end

  def find(uuid)
    repository[uuid]
  end

  private
  def handle_order_created(event)
    order = Dto.new(event.order_id, event.user_id, event.customer_name, {}, 0, event.status, [])
    repository[event.order_id] = order
  end

  def handle_order_quantity_updated(event)
    order = find(event.order_id)
    order.total += event.price
    order.products[event.product_id][1] = event.quantity
  end

  def handle_order_cancelled(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.reason
  end

  def handle_order_held(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.reason
  end

  def handle_order_shipped(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.comments
  end

  def handle_product_added_to_order(event)
    order = find(event.order_id)
    order.total += event.price
    order.products[event.product_id] = [event.product_name, event.quantity, event.unit_price]
  end

  def handle_product_removed_from_order(event)
    order = find(event.order_id)
    order.total -= event.price
    order.products.delete(event.product_id)
  end
end