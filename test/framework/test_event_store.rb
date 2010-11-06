class TestFrameworkEventStorage < Test::Unit::TestCase
  def test_retrieve_invalid_aggregate
    es = event_store
    assert_raises Aftermath::EventStore::AggregateNotFound do
      es.find('abc')
    end
  end

  def test_store_and_retrieve
    es = event_store
    uuid = Aftermath.uuid
    created = Event(:ShippingProviderCreated, :provider_id => uuid, :name => 'UPS', :state => 'active')
    activated = Event(:ShippingProviderActivated, :provider_id => uuid, :reason => 'test')
    deactivated = Event(:ShippingProviderDeactivated, :provider_id => uuid, :reason => 'test')
    events = [created, activated, deactivated, activated]
    es.save(Aggregates::ShippingProvider, uuid, events)
    provider = domain_repository(es).find(uuid)
    assert provider.changes.empty?
    assert_equal uuid, provider.uuid
    assert_equal 'active', provider.instance_variable_get(:@state)
    assert_equal 4, provider.version
    provider.deactivate('test')
    assert_events provider, :ShippingProviderDeactivated
    es.save(provider.class, provider.uuid, provider.changes, provider.version)
    assert_equal 5, domain_repository(es).find(uuid).version
  end

  def test_store_concurrency
    es = event_store
    uuid = Aftermath.uuid
    created = Event(:ShippingProviderCreated, :provider_id => uuid, :name => 'UPS', :state => 'active')
    deactivated = Event(:ShippingProviderDeactivated, :provider_id => uuid, :reason => 'test')
    es.save(Aggregates::ShippingProvider, uuid, [created])
    provider = domain_repository(es).find(uuid)
    assert_equal 1, provider.version
    assert_raises Aftermath::EventStore::ConcurrencyError do
      es.save(Aggregates::ShippingProvider, uuid, [deactivated], 2)
    end
    es.save(Aggregates::ShippingProvider, uuid, [deactivated], provider.version)
    provider = domain_repository(es).find(uuid)
    assert_equal 2, provider.version
    assert_equal 'inactive', provider.instance_variable_get(:@state)
  end

  def test_publish
    es = event_store
    reporting_queue = []
    es.subscribe{|e| reporting_queue << e }
    uuid = Aftermath.uuid
    created = Event(:ShippingProviderCreated, :provider_id => uuid, :name => 'UPS', :state => 'active')
    es.save(Aggregates::ShippingProvider, uuid, [created])
    assert_equal [Events::ShippingProviderCreated], reporting_queue.map{|e| e.class }
  end
end