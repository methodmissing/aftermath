class TestReportingShowCart < Test::Unit::TestCase
  include ReportingTest

  def test_cart_created
    Reporting << Event(:CartCreated, :cart_id => uuid)
    dto = Reporting.show_cart.find(uuid)
    assert_equal uuid, dto.cart_id
    assert_equal 0, dto.total
    assert_equal({}, dto.products)
    assert_equal({}, dto.coupons)
  end

  def test_product_added_to_cart
    Reporting << Event(:CartCreated, :cart_id => uuid)
    Reporting << Event(:ProductAddedToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :cart_total => 20, :quantity => 2)
    dto = Reporting.show_cart.find(uuid)
    assert_equal 20, dto.total
    assert_equal ["Delta", 2, 10], dto.products[1]
    assert dto.coupons.empty?
  end

  def test_product_removed_from_cart
    Reporting << Event(:CartCreated, :cart_id => uuid)
    Reporting << Event(:ProductAddedToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :cart_total => 20, :quantity => 2)
    Reporting << Event(:ProductRemovedFromCart, :cart_id => uuid, :product_id => 1, :unit_price => 10, :cart_total => 10)
    dto = Reporting.show_cart.find(uuid)
    assert_equal 10, dto.total
    assert dto.products.empty?
    assert dto.coupons.empty?
  end

  def test_cart_cleared
    Reporting << Event(:CartCreated, :cart_id => uuid)
    Reporting << Event(:ProductAddedToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :cart_total => 0, :quantity => 2)
    Reporting << Event(:CartCleared, :cart_id => uuid)
    dto = Reporting.show_cart.find(uuid)
    assert_equal 0, dto.total
    assert dto.products.empty?
    assert dto.coupons.empty?
  end

  def test_cart_quantity_updated
    Reporting << Event(:CartCreated, :cart_id => uuid)
    Reporting << Event(:ProductAddedToCart, :cart_id => uuid, :product_id => 1, :product_name => 'Delta', :unit_price => 10, :cart_total => 20, :quantity => 2)
    Reporting << Event(:CartQuantityUpdated, :cart_id => uuid, :product_id => 1, :unit_price => 10, :cart_total => 10, :quantity => 1)
    dto = Reporting.show_cart.find(uuid)
    assert_equal 10, dto.total
    assert_equal ["Delta", 1, 10], dto.products[1]
    assert dto.coupons.empty?
  end
end