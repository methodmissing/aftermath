class TestAggregatesOrder < Test::Unit::TestCase
  include AggregateTest
  def test_create_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    assert_published :OrderCreated
  end

  def test_add_product_to_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    Domain << Command(:AddProductToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    assert_published :OrderCreated, :ProductAddedToOrder
  end

  def test_remove_product_from_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    Domain << Command(:AddProductToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:RemoveProductFromOrder, :order_id => uuid, :product_id => 1, :price => 5)
    assert_published :OrderCreated, :ProductAddedToOrder, :ProductRemovedFromOrder
  end

  def test_hold_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    Domain << Command(:AddProductToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:HoldOrder, :order_id => uuid, :reason => 'Out of stock')
    assert_published :OrderCreated, :ProductAddedToOrder, :OrderHeld
  end

  def test_cancel_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    Domain << Command(:AddProductToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:CancelOrder, :order_id => uuid, :reason => 'Insufficient funds')
    assert_published :OrderCreated, :ProductAddedToOrder, :OrderCancelled
  end

  def test_ship_order
    Domain << Command(:CreateOrder, :order_id => uuid, :user_id => 2, :customer_name => 'John', :status => :open)
    Domain << Command(:AddProductToOrder, :order_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:ShipOrder, :order_id => uuid, :comments => 'Shipped with UPS Express')
    assert_published :OrderCreated, :ProductAddedToOrder, :OrderShipped
  end
end