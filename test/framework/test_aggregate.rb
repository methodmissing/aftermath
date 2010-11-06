class TestFrameworkAggregate < Test::Unit::TestCase
  include Aggregates

  def test_version
    assert_equal 1, ShippingProvider.version
  end

  def test_members
    assert [:name, :state, :uuid].all?{|m| ShippingProvider.members.include?(m) }
  end

  def test_reconstitute
    json = '{"name":"Shipping Lda.","__name__":"Aggregates::ShippingProvider","state":"active"}'
    sp = ShippingProvider.reconstitute(json)
    assert_equal 'Shipping Lda.', sp.instance_variable_get(:@name)
    assert_equal 'active', sp.instance_variable_get(:@state)
  end

  def test_snapshot_threshold
    assert_equal 10, ShippingProvider.snapshot_threshold
  end

  def test_public_mutator
    json = '{"name":"Shipping Lda.","__name__":"Aggregates::ShippingProvider","state":"inactive"}'
    sp = ShippingProvider.reconstitute(json)
    sp.activate('test')
    assert_equal 'active', sp.instance_variable_get(:@state)
    assert_equal 1, sp.changes.size
    event = sp.changes.shift
    assert_instance_of Events::ShippingProviderActivated, event
  end

  def test_uuid
    sp = ShippingProvider.new
    assert_equal 32, sp.uuid.size
    sp.instance_variable_set(:@uuid, 'abc')
    assert_equal 'abc', sp.uuid
  end

  def test_changes
    json = '{"name":"Shipping Lda.","__name__":"Aggregates::ShippingProvider","state":"inactive"}'
    sp = ShippingProvider.reconstitute(json)
    sp.activate('test')
    sp.deactivate('test')
    assert_equal 2, sp.changes.size
    assert_events sp, :ShippingProviderActivated, :ShippingProviderDeactivated
  end

  def test_commit
    json = '{"name":"Shipping Lda.","__name__":"Aggregates::ShippingProvider","state":"inactive"}'
    sp = ShippingProvider.reconstitute(json)
    sp.activate('test')
    assert_equal 1, sp.changes.size
    sp.commit
    assert_no_events sp
  end

  def test_rebuild
    activated = Event(:ShippingProviderActivated)
    deactivated = Event(:ShippingProviderDeactivated)
    events = [activated, deactivated, activated]
    sp = ShippingProvider.rebuild(events)
    assert_equal 'active', sp.instance_variable_get(:@state)
    assert_equal 0, sp.changes.size
    assert_no_events sp
    sp.rebuild [deactivated]
    assert_equal 'inactive', sp.instance_variable_get(:@state)
  end
end