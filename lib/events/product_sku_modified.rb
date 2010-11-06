class Events::ProductSkuModified < Aftermath::Event
  member :product_id
  member :sku
end