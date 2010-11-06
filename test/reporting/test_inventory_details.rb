class TestReportingInventoryDetails < Test::Unit::TestCase
  include ReportingTest

  def test_inventory_created
    view = Reporting::InventoryDetails.new({})
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    dto = view.find(uuid)
    assert_equal uuid, dto.inventory_id
    assert_equal 1, dto.product_id
    assert_equal 'A', dto.rack
    assert_equal 'X', dto.shelf
    assert_equal 10, dto.quantity
  end

  def test_inventory_relocated
    view = Reporting::InventoryDetails.new({})
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    view << Event(:InventoryRelocated, :inventory_id => uuid, :product_id => 1, :rack => 'B', :shelf => 'Y')
    dto = view.find(uuid)
    assert_equal 'B', dto.rack
    assert_equal 'Y', dto.shelf
  end

  def test_inventory_added
    view = Reporting::InventoryDetails.new({})
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    view << Event(:InventoryAdded, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = view.find(uuid)
    assert_equal 15, dto.quantity
  end

  def test_inventory_removed
    view = Reporting::InventoryDetails.new({})
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    view << Event(:InventoryRemoved, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = view.find(uuid)
    assert_equal 5, dto.quantity
  end
end