class TestFrameworkCore < Test::Unit::TestCase
  def string_underscore
    s = 'OrderShipping'
    assert_equal 'order_shipping', s.to_underscore
    assert_equal 'order_shipping', s.to_underscore!
    assert_equal 'order_shipping', s
  end
end