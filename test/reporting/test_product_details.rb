class TestReportingProductDetails < Test::Unit::TestCase
  include ReportingTest

  def test_product_created
    view = Reporting::ProductDetails.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    dto = view.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'XY', dto.sku
  end

  def test_product_renamed
    view = Reporting::ProductDetails.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    view << Event(:ProductRenamed, :product_id => uuid, :name => 'Delta Renamed')
    dto = view.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta Renamed', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'XY', dto.sku
  end

  def test_product_sku_modified
    view = Reporting::ProductDetails.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    view << Event(:ProductSkuModified, :product_id => uuid, :sku => 'YZ')
    dto = view.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'coffee', dto.category
    assert_equal 'YZ', dto.sku
  end

  def test_product_categorized
    view = Reporting::ProductDetails.new({})
    view << Event(:ProductCreated, :product_id => uuid, :name => 'Delta', :sku => 'XY', :category => 'coffee')
    view << Event(:ProductCategorized, :product_id => uuid, :category => 'tea')
    dto = view.find(uuid)
    assert_equal uuid, dto.product_id
    assert_equal 'Delta', dto.name
    assert_equal 'tea', dto.category
    assert_equal 'XY', dto.sku
  end
end