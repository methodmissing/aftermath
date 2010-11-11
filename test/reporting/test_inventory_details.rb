class TestReportingInventoryDetails < Test::Unit::TestCase
  include ReportingTest

  def test_inventory_created
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    dto = Reporting.inventory_details.find(uuid)
    assert_equal uuid, dto.inventory_id
    assert_equal 1, dto.product_id
    assert_equal 'A', dto.rack
    assert_equal 'X', dto.shelf
    assert_equal 10, dto.quantity
  end

  def test_inventory_relocated
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    Reporting << Event(:InventoryRelocated, :inventory_id => uuid, :product_id => 1, :rack => 'B', :shelf => 'Y')
    dto = Reporting.inventory_details.find(uuid)
    assert_equal 'B', dto.rack
    assert_equal 'Y', dto.shelf
  end

  def test_inventory_added
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    Reporting << Event(:InventoryAdded, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = Reporting.inventory_details.find(uuid)
    assert_equal 15, dto.quantity
  end

  def test_inventory_removed
    Reporting << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    Reporting << Event(:InventoryRemoved, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = Reporting.inventory_details.find(uuid)
    assert_equal 5, dto.quantity
  end
end