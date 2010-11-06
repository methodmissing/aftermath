class Commands::UpdateOrderQuantity < Aftermath::Command
  member :order_id
  member :product_id
  member :quantity
end