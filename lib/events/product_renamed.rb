class Events::ProductRenamed < Aftermath::Event
  member :product_id
  member :name
end