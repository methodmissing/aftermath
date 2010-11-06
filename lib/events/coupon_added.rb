class Events::CouponAdded < Aftermath::Event
  member :cart_id
  member :code
  member :discount
end