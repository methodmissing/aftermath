module CommandHandlers::AddInventory
  def handle_add_inventory(command)
    inventory = repository.find(command.inventory_id)
    inventory.add_stock(command.quantity)
    repository.save(inventory)
  end
end