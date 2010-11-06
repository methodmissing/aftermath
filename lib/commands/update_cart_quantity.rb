class Commands::UpdateCartQuantity < Aftermath::Command
  member :cart_id
  member :product_id
  member :quantity
  member :price
end