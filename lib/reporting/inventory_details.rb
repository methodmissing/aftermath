class Reporting::InventoryDetails < Aftermath::Handler
  class Dto < Struct.new(:inventory_id, :product_id, :quantity, :rack, :shelf)
  end

  def find(uuid)
    repository[uuid]
  end

  private
  def handle_inventory_created(event)
    inventory = Dto.new(event.inventory_id, event.product_id, event.quantity, event.rack,
                        event.shelf)
    repository[event.inventory_id] = inventory
  end

  def handle_inventory_added(event)
    inventory = find(event.inventory_id)
    inventory.quantity += event.quantity
  end

  def handle_inventory_relocated(event)
    inventory = find(event.inventory_id)
    inventory.rack = event.rack
    inventory.shelf = event.shelf
  end

  def handle_inventory_removed(event)
    inventory = find(event.inventory_id)
    inventory.quantity -= event.quantity
  end
end