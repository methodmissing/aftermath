class Reporting::ListInventory < Aftermath::Handler
  class Dto < Struct.new(:inventory_id, :product_id, :product_name, :quantity)
  end

  def find(uuid)
    repository[uuid]
  end

  def list
    repository.values
  end

  private
  def handle_inventory_created(event)
    repository[event.inventory_id] = Dto.new(event.inventory_id, event.product_id, event.product_name, event.quantity)
  end

  def handle_inventory_added(event)
    inventory = find(event.inventory_id)
    inventory.quantity += event.quantity
  end

  def handle_inventory_removed(event)
    inventory = find(event.inventory_id)
    inventory.quantity -= event.quantity
  end
end