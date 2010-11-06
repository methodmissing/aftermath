class Events::OrderHeld < Aftermath::Event
  member :order_id
  member :status
  member :reason
end