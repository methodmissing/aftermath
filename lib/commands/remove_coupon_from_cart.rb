class Commands::RemoveCouponFromCart < Aftermath::Command
  member :cart_id
  member :code
  member :discount
end