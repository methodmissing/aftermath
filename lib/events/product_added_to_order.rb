class Events::ProductAddedToOrder < Aftermath::Event
  member :order_id
  member :product_id
  member :product_name
  member :unit_price
  member :order_total
  member :quantity
end