class Commands::CreateProduct < Aftermath::Command
  member :product_id
  member :name
  member :sku
  member :category
end