class Events::OrderCreated < Aftermath::Event
  member :order_id
  member :user_id
  member :customer_name
  member :status
end