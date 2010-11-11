class Aggregates::Inventory < Aftermath::Aggregate
  property :product_id
  property :product_name
  property :rack
  property :shelf
  property :quantity

  def initialize(data = nil)
    if data
      apply Event(:InventoryCreated, :inventory_id => data[:uuid],
                                     :product_id => data[:product_id],
                                     :product_name => data[:product_name],
                                     :rack => Rack(data[:rack]).to_s,
                                     :shelf => Shelf(data[:shelf]).to_s,
                                     :quantity => data[:quantity])
    end
  end

  def add_stock(quantity)
    apply Event(:InventoryAdded, :inventory_id => uuid, :product_id => @product_id, :quantity => @quantity + quantity)
  end

  def remove_stock(quantity)
    apply Event(:InventoryRemoved, :inventory_id => uuid, :product_id => @product_id, :quantity => @quantity - quantity)
  end

  def relocate(rack, shelf)
    apply Event(:InventoryRelocated, :inventory_id => uuid, :product_id => @product_id, :rack => Rack(rack).to_s, :shelf => Shelf(shelf).to_s)
  end

  private
  def apply_inventory_created(event)
    @uuid = event.inventory_id
    @product_id = event.product_id
    @product_name = event.product_name
    @rack = event.rack
    @shelf = event.shelf
    @quantity = event.quantity
  end

  def apply_inventory_added(event)
    @quantity = event.quantity
  end

  def apply_inventory_removed(event)
    @quantity = event.quantity
  end

  def apply_inventory_relocated(event)
    @rack = event.rack
    @shelf = event.shelf
  end
end