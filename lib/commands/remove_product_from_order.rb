class Commands::RemoveProductFromOrder < Aftermath::Command
  member :order_id
  member :product_id
  member :price
end