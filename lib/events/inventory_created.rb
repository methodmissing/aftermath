class Events::InventoryCreated < Aftermath::Event
  member :inventory_id
  member :product_id
  member :product_name
  member :rack
  member :shelf
  member :quantity
end