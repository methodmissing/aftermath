module CommandHandlers::RelocateInventory
  def handle_relocate_inventory(command)
    inventory = repository.find(command.inventory_id)
    inventory.relocate(command.rack, command.shelf)
    repository.save(inventory)
  end
end