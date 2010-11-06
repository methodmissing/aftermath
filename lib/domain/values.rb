module Values
  def self.value(v)
    require "domain/values/#{v.to_s.to_underscore}"
  end

  value :Rack
  value :Category
  value :Shelf
  value :OrderStatus
end