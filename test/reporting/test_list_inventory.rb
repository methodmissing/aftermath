class TestReportingListInventory < Test::Unit::TestCase
  include ReportingTest

  def test_inventory_created
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    dto = Reporting.list_inventory.filter.first
    assert_equal uuid, dto.inventory_id
    assert_equal 1, dto.product_id
    assert_equal 'Delta', dto.product_name
    assert_equal 10, dto.quantity
    Reporting << Event(:InventoryCreated, :inventory_id => uuid << '2', :product_id => 1,
                                         :product_name => 'Delta 2', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    assert_equal 2, Reporting.list_inventory.filter.size
  end

  def test_inventory_added
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    Reporting << Event(:InventoryAdded, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = Reporting.list_inventory.filter.shift
    assert_equal 15, dto.quantity
  end

  def test_inventory_removed
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    Reporting << Event(:InventoryRemoved, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = Reporting.list_inventory.filter.shift
    assert_equal 5, dto.quantity
  end
end