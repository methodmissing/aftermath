class Reporting::OrderDetails < Aftermath::View
  class Dto < Struct.new(:order_id, :user_id, :customer_name, :products, :total, :status, :comments)
  end

  private
  def self.handle_order_created(event)
    order = Dto.new(event.order_id, event.user_id, event.customer_name, {}, 0, event.status, [])
    repository[event.order_id] = order
  end

  def self.handle_order_quantity_updated(event)
    order = find(event.order_id)
    order.total = event.order_total
    order.products[event.product_id][1] = event.quantity
  end

  def self.handle_order_cancelled(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.reason
  end

  def self.handle_order_held(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.reason
  end

  def self.handle_order_shipped(event)
    order = find(event.order_id)
    order.status = event.status
    order.comments << event.comments
  end

  def self.handle_product_added_to_order(event)
    order = find(event.order_id)
    order.total = event.order_total
    order.products[event.product_id] = [event.product_name, event.quantity, event.unit_price]
  end

  def self.handle_product_removed_from_order(event)
    order = find(event.order_id)
    order.total = event.order_total
    order.products.delete(event.product_id)
  end
end