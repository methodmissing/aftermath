class Commands::RemoveProductFromCart < Aftermath::Command
  member :cart_id
  member :product_id
  member :price
end