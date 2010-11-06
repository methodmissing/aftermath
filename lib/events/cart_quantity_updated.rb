class Events::CartQuantityUpdated < Aftermath::Event
  member :cart_id
  member :product_id
  member :quantity
  member :unit_price
  member :price
end