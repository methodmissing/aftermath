class Reporting::ListInventory < Aftermath::Handler
  class Dto < Struct.new(:inventory_id, :product_id, :product_name, :quantity)
  end

  def list
    repository
  end

  private
  def find(uuid)
    repository.detect{|i| i.inventory_id == uuid }
  end

  def handle_inventory_created(event)
    repository << Dto.new(event.inventory_id, event.product_id, event.product_name, event.quantity)
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