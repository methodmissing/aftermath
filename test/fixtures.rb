class Aggregates::ShippingProvider < Aftermath::Aggregate
  self.version = 1
  self.snapshot_threshold = 10

  property :name
  property :state

  def activate(reason)
    apply Event(:ShippingProviderActivated, :provider_id => uuid, :reason => reason)
  end

  def deactivate(reason)
    apply Event(:ShippingProviderDeactivated, :provider_id => uuid, :reason => reason)
  end

  private
  def apply_shipping_provider_created(event)
    @uuid = event.provider_id
    @name = event.name
    @state = event.state
  end

  def apply_shipping_provider_activated(event)
    @state = 'active'
  end

  def apply_shipping_provider_deactivated(event)
    @state = 'inactive'
  end
end

class StubMessage
  include Aftermath::Message

  self.version = 2

  member :product_id
  member :name
end

class Commands::DisableShippingProvider < Aftermath::Command
  member :provider_id
  member :reason
end

class Events::ShippingProviderCreated < Aftermath::Event
  member :provider_id
  member :name
  member :state
end

class Events::ShippingProviderActivated < Aftermath::Event
  member :provider_id
  member :reason
end

class Events::ShippingProviderDeactivated < Aftermath::Event
  member :provider_id
  member :reason
end

class ProductView < Aftermath::View
end