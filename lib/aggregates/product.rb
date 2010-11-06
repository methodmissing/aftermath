class Aggregates::Product < Aftermath::Aggregate
  property :name
  property :sku
  property :category

  def initialize(data = nil)
    if data
      apply Event(:ProductCreated, :product_id => data[:uuid],
                                   :name => data[:name],
                                   :sku => data[:sku],
                                   :category => Category(data[:category]).to_s)
    end
  end

  def rename(name)
    apply Event(:ProductRenamed, :product_id => uuid, :name => name)
  end

  def modify_sku(sku)
    apply Event(:ProductSkuModified, :product_id => uuid, :sku => sku)
  end

  def categorize(category)
    apply Event(:ProductCategorized, :product_id => uuid, :category => Category(category).to_s)
  end

  private
  def apply_product_created(event)
    @uuid = event.product_id
    @name = event.name
    @sku = event.sku
    @category = event.category
  end

  def apply_product_renamed(event)
    @name = event.name
  end

  def apply_product_sku_modified(event)
    @sku = event.sku
  end

  def apply_product_categorized(event)
    @category = event.category
  end
end