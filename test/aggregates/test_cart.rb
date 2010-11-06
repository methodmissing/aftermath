class TestAggregatesCart < Test::Unit::TestCase
  include AggregateTest
  def test_create_cart
    Domain << Command(:CreateCart, :cart_id => uuid)
    assert_published :CartCreated
  end

  def test_add_product_to_cart
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    assert_published :CartCreated, :ProductAddedToCart
  end

  def test_remove_product_from_cart
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:RemoveProductFromCart, :cart_id => uuid, :product_id => 1, :price => 5)
    assert_published :CartCreated, :ProductAddedToCart, :ProductRemovedFromCart
  end

  def test_clear_cart
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:ClearCart, :cart_id => uuid)
    assert_published :CartCreated, :ProductAddedToCart, :CartCleared
  end

  def test_add_coupon
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:AddCouponToCart, :cart_id => uuid, :code => 'abcd', :discount => 2)
    assert_published :CartCreated, :ProductAddedToCart, :CouponAdded
  end

  def test_remove_coupon
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:AddCouponToCart, :cart_id => uuid, :code => 'abcd', :discount => 2)
    Domain << Command(:RemoveCouponFromCart, :cart_id => uuid, :code => 'abcd', :discount => 2)
    assert_published :CartCreated, :ProductAddedToCart, :CouponAdded, :CouponRemoved
  end

  def test_update_cart_quantity
    Domain << Command(:CreateCart, :cart_id => uuid)
    Domain << Command(:AddProductToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :price => 5, :quantity => 2)
    Domain << Command(:UpdateCartQuantity, :cart_id => uuid, :product_id => 1, :price => 5, :quantity => 5)
    assert_published :CartCreated, :ProductAddedToCart, :CartQuantityUpdated
  end
end