class TestFrameworkDomainRepository < Test::Unit::TestCase
  def test_store_and_retrieve
    r = domain_repository
    uuid = Aftermath.uuid
    created = Event(:ShippingProviderCreated, :provider_id => uuid, :name => 'UPS', :state => 'active')
    activated = Event(:ShippingProviderActivated, :provider_id => uuid, :reason => 'test')
    deactivated = Event(:ShippingProviderDeactivated, :provider_id => uuid, :reason => 'test')
    events = [created, activated, deactivated, activated]
    provider = Aggregates::ShippingProvider.new
    events.each{|e| provider.apply(e) }
    assert !provider.changes.empty?
    r.save(provider)
    assert provider.changes.empty?
    provider = r.find(uuid)
    assert_equal 4, provider.version
  end
end