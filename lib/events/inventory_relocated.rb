class Events::InventoryRelocated < Aftermath::Event
  member :inventory_id
  member :product_id
  member :rack
  member :shelf
end