class TestReportingProductDetails < Test::Unit::TestCase
  include ReportingTest

  def test_product_created
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    dto = Reporting.product_details.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'XY', dto.sku
  end

  def test_product_renamed
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    Reporting << Event(:ProductRenamed, :product_id => uuid, :name => 'Delta Renamed')
    dto = Reporting.product_details.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta Renamed', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'XY', dto.sku
  end

  def test_product_sku_modified
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    Reporting << Event(:ProductSkuModified, :product_id => uuid, :sku => 'YZ')
    dto = Reporting.product_details.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'YZ', dto.sku
  end

  def test_product_categorized
    Reporting << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    Reporting << Event(:ProductCategorized, :product_id => uuid, :category => 'tea')
    dto = Reporting.product_details.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'tea', dto.category
    assert_equal 'XY', dto.sku
  end
end