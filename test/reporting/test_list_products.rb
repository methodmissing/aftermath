class TestReportingListProducts < Test::Unit::TestCase
  include ReportingTest

  def test_product_created
    view = Reporting::ListProducts.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    dto = view.list.first
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'XY', dto.sku

    view << Event(:ProductCreated, :product_id => uuid << '2', :name => 'Delta 2', :sku => 'XY', :category => 'coffee')
    assert_equal 2, view.list.size
  end

  def test_product_renamed
    view = Reporting::ListProducts.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    view << Event(:ProductRenamed, :product_id => uuid, :name => 'Delta Renamed')
    dto = view.list.first
    assert_equal 'Delta Renamed', dto.name
  end

  def test_product_sku_modified
    view = Reporting::ListProducts.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    view << Event(:ProductSkuModified, :product_id => uuid, :sku => 'YZ')
    dto = view.list.first
    assert_equal 'YZ', dto.sku
  end
end