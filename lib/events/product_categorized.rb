class Events::ProductCategorized < Aftermath::Event
  member :product_id
  member :category
end