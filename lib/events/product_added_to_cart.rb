class Events::ProductAddedToCart < Aftermath::Event
  member :cart_id
  member :product_id
  member :product_name
  member :unit_price
  member :cart_total
  member :quantity
end