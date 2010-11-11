class Reporting::ListInventory < Aftermath::View
  class Dto < Struct.new(:inventory_id, :product_id, :product_name, :quantity)
  end

  private
  def self.handle_inventory_created(event)
    repository[event.inventory_id] = Dto.new(event.inventory_id, event.product_id, event.product_name, event.quantity)
  end

  def self.handle_inventory_added(event)
    inventory = find(event.inventory_id)
    inventory.quantity = event.quantity
  end

  def self.handle_inventory_removed(event)
    inventory = find(event.inventory_id)
    inventory.quantity = event.quantity
  end
end