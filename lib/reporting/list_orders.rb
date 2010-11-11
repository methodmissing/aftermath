class Reporting::ListOrders < Aftermath::View
  class Dto < Struct.new(:order_id, :user_id, :customer_name, :total, :status)
  end

  private
  def self.handle_order_created(event)
    repository[event.order_id] = Dto.new(event.order_id, event.user_id, event.customer_name, 0, event.status)
  end

  def self.handle_order_quantity_updated(event)
    order = find(event.order_id)
    order.total = event.order_total
  end

  def self.handle_order_cancelled(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def self.handle_order_held(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def self.handle_order_shipped(event)
    order = find(event.order_id)
    order.status = event.status
  end

  def self.handle_product_added_to_order(event)
    order = find(event.order_id)
    order.total = event.order_total
  end

  def self.handle_product_removed_from_order(event)
    order = find(event.order_id)
    order.total = event.order_total
  end
end