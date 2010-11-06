class Commands::AddProductToCart < Aftermath::Command
  member :cart_id
  member :product_id
  member :product_name
  member :price
  member :quantity
end