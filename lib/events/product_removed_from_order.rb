class Events::ProductRemovedFromOrder < Aftermath::Event
  member :order_id
  member :product_id
  member :unit_price
  member :price
end