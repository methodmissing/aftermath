module Reporting
  class << self
    def view(v)
      ref = v.to_s.to_underscore
      require "reporting/#{ref}"
      instance_eval <<-"evl", __FILE__, __LINE__
        def #{ref}; #{v}; end
      evl
      views << const_get(v)
    end

    def handle(event)
      events << event
    end
    alias << handle

    def subscribe(&b)
      events.subscribe(&b)
    end

    def events
      @events ||= Aftermath::Channel.new
    end

    def boot
      views.each do |v|
        subscribe{|e| v << e }
      end
    end

    def views
      @views ||= []
    end
  end

  view :ShowCart
  view :OrderDetails
  view :ListOrders
  view :ProductDetails
  view :ListProducts
  view :InventoryDetails
  view :ListInventory
end