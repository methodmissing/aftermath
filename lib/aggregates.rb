module Aggregates
  def self.aggregate(a)
    autoload a, "aggregates/#{a.to_s.to_underscore}"
    aggregates << a
  end

  def self.aggregates
    @aggregates ||= []
  end

  def self.assert
    aggregates.each{|a| Aggregates.const_get(a) }
  end

  aggregate :Cart
  aggregate :Inventory
  aggregate :Order
  aggregate :Product
end

module Kernel
  private
  def Aggregate(agg)
    Aggregates.const_get(agg)
  end
end