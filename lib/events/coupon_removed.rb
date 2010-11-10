class Events::CouponRemoved < Aftermath::Event
  member :cart_id
  member :code
  member :discount
  member :cart_total
end