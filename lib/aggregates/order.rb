class Aggregates::Order < Aftermath::Aggregate
  property :user_id
  property :customer_name
  property :products
  property :total
  property :status
  property :comments

  def initialize(data = nil)
    if data
      apply Event(:OrderCreated, :order_id => data[:uuid],
                                 :user_id => data[:user_id],
                                 :customer_name => data[:customer_name],
                                 :status => OrderStatus(data[:status]).to_s)
    end
  end

  def add_product(product_id, product_name, price, quantity)
    delta = quantity * price
    apply Event(:ProductAddedToOrder, :order_id => uuid,
                                      :product_id => product_id,
                                      :product_name => product_name,
                                      :unit_price => price,
                                      :order_total => @total + delta,
                                      :quantity => quantity)
  end

  def remove_product(product_id, price)
    delta = @products[product_id] * price
    apply Event(:ProductRemovedFromOrder, :order_id => uuid,
                                          :product_id => product_id, 
                                          :unit_price => price,
                                          :order_total => @total - delta)
  end

  def update_quantity(product_id, price, quantity)
    delta = (@products[product_id] - quantity) * price
    apply Event(:OrderQuantityUpdated, :order_id => uuid, 
                                       :product_id => product_id,
                                       :unit_price => price,
                                       :order_total => @total + delta,
                                       :quantity => quantity)
  end

  def cancel(reason)
    apply Event(:OrderCancelled, :order_id => uuid, :status => OrderStatus(:cancelled).to_s, :reason => reason)
  end

  def ship(comments)
    apply Event(:OrderShipped, :order_id => uuid, :status => OrderStatus(:shipped).to_s, :comments => comments)
  end

  def hold(reason)
    apply Event(:OrderHeld, :order_id => uuid, :status => OrderStatus(:held).to_s, :reason => reason)
  end

  private
  def apply_order_created(event)
    @uuid = event.order_id
    @user_id = event.user_id
    @customer_name = event.customer_name
    @status = event.status
    @products = {}
    @total = 0
    @comments = []
  end

  def apply_product_added_to_order(event)
    @products[event.product_id] = event.quantity
    @total = event.order_total
  end

  def apply_product_removed_from_order(event)
    @products.delete(event.product_id)
    @total = event.order_total
  end

  def apply_order_quantity_updated(event)
    @products[event.product_id] = event.quantity
    @total = event.order_total
  end

  def apply_order_cancelled(event)
    @status = event.status
    @comments << event.reason
  end

  def apply_order_shipped(event)
    @status = event.status
    @comments << event.comments
  end

  def apply_order_held(event)
    @status = event.status
    @comments << event.reason
  end
end