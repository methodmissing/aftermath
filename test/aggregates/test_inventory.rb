class TestAggregatesInventory < Test::Unit::TestCase
  include AggregateTest
  def test_create_inventory
    Domain << Command(:CreateInventory, :inventory_id => uuid, :product_id => 123, :product_name => 'Delta', :rack => 'A', :shelf => 'X', :quantity => 10)
    assert_published :InventoryCreated
  end

  def test_add_inventory
    Domain << Command(:CreateInventory, :inventory_id => uuid, :product_id => 123, :product_name => 'Delta', :rack => 'A', :shelf => 'X', :quantity => 10)
    Domain << Command(:AddInventory, :inventory_id => uuid, :quantity => 10)
    assert_published :InventoryCreated, :InventoryAdded
  end

  def test_remove_inventory
    Domain << Command(:CreateInventory, :inventory_id => uuid, :product_id => 123, :product_name => 'Delta', :rack => 'A', :shelf => 'X', :quantity => 10)
    Domain << Command(:AddInventory, :inventory_id => uuid, :quantity => 10)
    Domain << Command(:RemoveInventory, :inventory_id => uuid, :quantity => 5)
    assert_published :InventoryCreated, :InventoryAdded, :InventoryRemoved
  end

  def test_relocate_inventory
    Domain << Command(:CreateInventory, :inventory_id => uuid, :product_id => 123, :product_name => 'Delta', :rack => 'A', :shelf => 'X', :quantity => 10)
    Domain << Command(:RelocateInventory, :inventory_id => uuid, :rack => 'B', :shelf => 'Y')
    assert_published :InventoryCreated, :InventoryRelocated
  end
end