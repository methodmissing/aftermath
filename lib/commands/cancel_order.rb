class Commands::CancelOrder < Aftermath::Command
  member :order_id
  member :reason
end