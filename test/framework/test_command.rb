class TestFrameworkCommand < Test::Unit::TestCase
  def test_to_hash
    m = Commands::DisableShippingProvider.new :provider_id => 12, :reason => 'fail'
    h = m.to_hash
    assert_equal 12, h[:provider_id]
    assert_equal 'fail', h[:reason]
    assert_equal 'Commands::DisableShippingProvider', h[:__name__]
    assert_equal 1, m.structural_version
  end
end