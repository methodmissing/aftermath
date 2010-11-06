module CommandHandlers::RemoveInventory
  def handle_remove_inventory(command)
    inventory = repository.find(command.inventory_id)
    inventory.remove_stock(command.quantity)
    repository.save(inventory)
  end
end