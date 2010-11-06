class Events::OrderCancelled < Aftermath::Event
  member :order_id
  member :status
  member :reason
end