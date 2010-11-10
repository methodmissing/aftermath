class TestReportingListOrders < Test::Unit::TestCase
  include ReportingTest

  def test_order_created
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    dto = view.list.first
    assert_equal uuid, dto.order_id
    assert_equal 1, dto.user_id
    assert_equal 'John', dto.customer_name
    assert_equal 0, dto.total
    assert_equal 'open', dto.status

    view << Event(:OrderCreated, :order_id => uuid << 2, :user_id => 1, :customer_name => 'John', :status => 'open')
    assert_equal 2, view.list.size
  end

  def test_product_added_to_order
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    dto = view.list.shift
    assert_equal 20, dto.total
    assert_equal 'open', dto.status
  end

  def test_product_removed_from_order
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    view << Event(:ProductRemovedFromOrder, :order_id => uuid, :product_id => 1, :unit_price => 10, :order_total => 10)
    dto = view.list.shift
    assert_equal 10, dto.total
    assert_equal 'open', dto.status
  end

  def test_order_quantity_updated
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    view << Event(:OrderQuantityUpdated, :order_id => uuid, :product_id => 1, :unit_price => 10, :order_total => 10, :quantity => 1)
    dto = view.list.shift
    assert_equal 10, dto.total
    assert_equal 'open', dto.status
  end

  def test_order_shipped
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    view << Event(:OrderShipped, :order_id => uuid, :status => 'shipped', :comments => 'On Time!')
    dto = view.list.shift
    assert_equal 20, dto.total
    assert_equal 'shipped', dto.status
  end

  def test_order_cancelled
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    view << Event(:OrderCancelled, :order_id => uuid, :status => 'cancelled', :reason => 'No Stock!')
    dto = view.list.shift
    assert_equal 20, dto.total
    assert_equal 'cancelled', dto.status
  end

  def test_order_held
    view = Reporting::ListOrders.new({})
    view << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    view << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    view << Event(:OrderHeld, :order_id => uuid, :status => 'held', :reason => 'No Monies!')
    dto = view.list.shift
    assert_equal 20, dto.total
    assert_equal 'held', dto.status
  end
end