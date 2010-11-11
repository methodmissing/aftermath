class TestReportingOrderDetails < Test::Unit::TestCase
  include ReportingTest

  def test_order_created
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    dto = Reporting.order_details.find(uuid)
    assert_equal uuid, dto.order_id
    assert_equal 1, dto.user_id
    assert_equal 'John', dto.customer_name
    assert_equal 0, dto.total
    assert_equal({}, dto.products)
    assert_equal 'open', dto.status
    assert_equal [], dto.comments
  end

  def test_product_added_to_order
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    dto = Reporting.order_details.find(uuid)
    assert_equal 20, dto.total
    assert_equal ["Delta", 2, 10], dto.products[1]
    assert_equal 'open', dto.status
  end

  def test_product_removed_from_order
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    Reporting << Event(:ProductRemovedFromOrder, :order_id => uuid, :product_id => 1, :unit_price => 10, :order_total => 0)
    dto = Reporting.order_details.find(uuid)
    assert_equal 0, dto.total
    assert dto.products.empty?
    assert_equal 'open', dto.status
  end

  def test_order_quantity_updated
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    Reporting << Event(:OrderQuantityUpdated, :order_id => uuid, :product_id => 1, :unit_price => 10, :order_total => 10, :quantity => 1)
    dto = Reporting.order_details.find(uuid)
    assert_equal 10, dto.total
    assert_equal ["Delta", 1, 10], dto.products[1]
    assert_equal 'open', dto.status
  end

  def test_order_shipped
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    Reporting << Event(:OrderShipped, :order_id => uuid, :status => 'shipped', :comments => 'On Time!')
    dto = Reporting.order_details.find(uuid)
    assert_equal 20, dto.total
    assert_equal ["Delta", 2, 10], dto.products[1]
    assert_equal 'shipped', dto.status
    assert_equal ['On Time!'], dto.comments
  end

  def test_order_cancelled
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    Reporting << Event(:OrderCancelled, :order_id => uuid, :status => 'cancelled', :reason => 'No Stock!')
    dto = Reporting.order_details.find(uuid)
    assert_equal 20, dto.total
    assert_equal ["Delta", 2, 10], dto.products[1]
    assert_equal 'cancelled', dto.status
    assert_equal ['No Stock!'], dto.comments
  end

  def test_order_held
    Reporting << Event(:OrderCreated, :order_id => uuid, :user_id => 1, :customer_name => 'John', :status => 'open')
    Reporting << Event(:ProductAddedToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :order_total => 20, :quantity => 2)
    Reporting << Event(:OrderHeld, :order_id => uuid, :status => 'held', :reason => 'No Monies!')
    dto = Reporting.order_details.find(uuid)
    assert_equal 20, dto.total
    assert_equal ["Delta", 2, 10], dto.products[1]
    assert_equal 'held', dto.status
    assert_equal ['No Monies!'], dto.comments
  end
end