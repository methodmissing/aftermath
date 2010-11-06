class TestFrameworkEvent < Test::Unit::TestCase
  def test_to_hash
    m = Events::ShippingProviderDeactivated.new :provider_id => 12, :reason => 'fail'
    h = m.to_hash
    assert_equal 12, h[:provider_id]
    assert_equal 'fail', h[:reason]
    assert_equal 'Events::ShippingProviderDeactivated', h[:__name__]
    assert_equal 1, m.structural_version
  end
end