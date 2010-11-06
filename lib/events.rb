module Events
  def self.event(e)
    autoload e, "events/#{e.to_s.to_underscore}"
    events << e
  end

  def self.events
    @events ||= []
  end

  def self.assert
    events.each{|e| Events.const_get(e) }
  end

  event :CartQuantityUpdated
  event :CouponAdded
  event :CartCleared
  event :CartCreated
  event :CouponRemoved
  event :ProductAddedToCart
  event :ProductRemovedFromCart

  event :InventoryAdded
  event :InventoryRelocated
  event :InventoryRemoved
  event :InventoryCreated

  event :OrderCancelled
  event :OrderHeld
  event :OrderQuantityUpdated
  event :OrderShipped
  event :OrderCreated
  event :ProductRemovedFromOrder

  event :ProductAddedToOrder
  event :ProductCategorized
  event :ProductRenamed
  event :ProductSkuModified
  event :ProductCreated
end

module Kernel
  private
  def Event(evt, attrs = nil)
    Events.const_get(evt).new(attrs)
  end
end