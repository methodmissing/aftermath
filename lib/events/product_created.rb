class Events::ProductCreated < Aftermath::Event
  member :product_id
  member :name
  member :sku
  member :category
end