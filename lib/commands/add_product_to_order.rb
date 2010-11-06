class Commands::AddProductToOrder < Aftermath::Command
  member :order_id
  member :product_id
  member :product_name
  member :price
  member :quantity
end