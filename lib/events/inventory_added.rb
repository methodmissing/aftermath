class Events::InventoryAdded < Aftermath::Event
  member :inventory_id
  member :product_id
  member :quantity
end