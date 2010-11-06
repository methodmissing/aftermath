module Reporting
  def self.view(v)
    autoload v, "reporting/#{v.to_s.to_underscore}"
    views << v
  end

  def self.views
    @views ||= []
  end

  view :ShowCart
  view :OrderDetails
  view :ListOrders
  view :ProductDetails
  view :ListProducts
  view :InventoryDetails
  view :ListInventory

  def handle(event)
    # TODO: filter by per view event subscriptions
  end

  def subscribe(&b)
    events.subscribe(&b)
  end

  def events
    @events ||= Aftermath::Channel.new
  end
end