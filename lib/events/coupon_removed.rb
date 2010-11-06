class Events::CouponRemoved < Aftermath::Event
  member :cart_id
  member :code
  member :discount
end