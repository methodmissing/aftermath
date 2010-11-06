class TestReportingListInventory < Test::Unit::TestCase
  include ReportingTest

  def test_inventory_created
    view = Reporting::ListInventory.new([])
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    dto = view.list.first
    assert_equal uuid, dto.inventory_id
    assert_equal 1, dto.product_id
    assert_equal 'Delta', dto.product_name
    assert_equal 10, dto.quantity
    view << Event(:InventoryCreated, :inventory_id => uuid << '2', :product_id => 1,
                                         :product_name => 'Delta 2', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    assert_equal 2, view.list.size
  end

  def test_inventory_added
    view = Reporting::ListInventory.new([])
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    view << Event(:InventoryAdded, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = view.list.shift
    assert_equal 15, dto.quantity
  end

  def test_inventory_removed
    view = Reporting::ListInventory.new([])
    view << Event(:InventoryCreated, :inventory_id => uuid, :product_id => 1,
                                         :product_name => 'Delta', :rack => 'A',
                                         :shelf => 'X', :quantity => 10)
    view << Event(:InventoryRemoved, :inventory_id => uuid, :product_id => 1, :quantity => 5)
    dto = view.list.shift
    assert_equal 5, dto.quantity
  end
end