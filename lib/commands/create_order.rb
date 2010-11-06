class Commands::CreateOrder < Aftermath::Command
  member :order_id
  member :user_id
  member :customer_name
  member :status
end