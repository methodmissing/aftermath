class Events::OrderQuantityUpdated < Aftermath::Event
  member :order_id
  member :product_id
  member :unit_price
  member :order_total
  member :quantity
end