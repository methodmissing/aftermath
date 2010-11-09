class TestValues < Test::Unit::TestCase
  def test_rack
    assert_equal 100, Rack('A').capacity
    assert_raises(ArgumentError){ Rack('Z') }
  end

  def test_shelf
    assert_equal 10, Shelf('X').capacity
    assert_raises(ArgumentError){ Shelf('A') }
  end

  def test_category
    assert_equal 'Coffee', Category('coffee').name
    assert_raises(ArgumentError){ Category('whiskey') }
  end

  def test_order_status
    assert_equal 'Open', OrderStatus('open').name
    assert_raises(ArgumentError){ OrderStatus('invalid') }
  end
end