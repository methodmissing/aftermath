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
      router[event.to_handler].each{|v| v.handle(event) }
    end
    alias << handle

    def subscribe(&b)
      events.subscribe(&b)
    end

    def events
      @events ||= Aftermath::Channel.new
    end

    def boot(rep = nil)
      @repository = rep
      views.each do |v|
        v.methods(true).grep(/handle_/).each{|m| router[m.gsub!(/handle_/,'')] << v }
      end
    end

    def views
      @views ||= []
    end

    private
    def router
      @router ||= Hash.new{|h,k| h[k] = []}
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