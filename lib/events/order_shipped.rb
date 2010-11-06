class Events::OrderShipped < Aftermath::Event
  member :order_id
  member :status
  member :comments
end