module CommandHandlers::CreateInventory
  def handle_create_inventory(command)
    inventory = Aggregates::Inventory.new :uuid => command.inventory_id,
                                          :product_id => command.product_id,
                                          :product_name => command.product_name,
                                          :rack => command.rack,
                                          :shelf => command.shelf,
                                          :quantity => command.quantity
    repository.save(inventory, -1)
  end
end