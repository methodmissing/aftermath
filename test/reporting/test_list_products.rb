class TestReportingListProducts < Test::Unit::TestCase
  include ReportingTest

  def test_product_created
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    dto = Reporting.list_products.filter.first
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'XY', dto.sku

    Reporting << Event(:ProductCreated, :product_id => uuid << '2', :name => 'Delta 2', :sku => 'XY', :category => 'coffee')
    assert_equal 2, Reporting.list_products.filter.size
  end

  def test_product_renamed
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    Reporting << Event(:ProductRenamed, :product_id => uuid, :name => 'Delta Renamed')
    dto = Reporting.list_products.filter.first
    assert_equal 'Delta Renamed', dto.name
  end

  def test_product_sku_modified
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    Reporting << Event(:ProductSkuModified, :product_id => uuid, :sku => 'YZ')
    dto = Reporting.list_products.filter.first
    assert_equal 'YZ', dto.sku
  end
end