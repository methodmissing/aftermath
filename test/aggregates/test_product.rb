class TestAggregatesProduct < Test::Unit::TestCase
  include AggregateTest
  def test_create_product
    Domain << Command(:CreateProduct, :product_id => uuid, :name => 'Delta', :sku => 'XYZ', :category => 'coffee')
    assert_published :ProductCreated
  end

  def test_rename_product
    Domain << Command(:CreateProduct, :product_id => uuid, :name => 'Delta', :sku => 'XYZ', :category => 'coffee')
    Domain << Command(:RenameProduct, :product_id => uuid, :name => 'Nescafe')
    assert_published :ProductCreated, :ProductRenamed
  end

  def test_modify_sku
    Domain << Command(:CreateProduct, :product_id => uuid, :name => 'Delta', :sku => 'XYZ', :category => 'coffee')
    Domain << Command(:ModifyProductSku, :product_id => uuid, :sku => 'ABC')
    assert_published :ProductCreated, :ProductSkuModified
  end

  def test_categorize_product
    Domain << Command(:CreateProduct, :product_id => uuid, :name => 'Delta', :sku => 'XYZ', :category => 'coffee')
    Domain << Command(:CategorizeProduct, :product_id => uuid, :category => 'blends')
    assert_published :ProductCreated, :ProductCategorized
  end
end