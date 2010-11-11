class Reporting::ListProducts < Aftermath::View
  class Dto < Struct.new(:product_id, :name, :sku)
  end

  private
  def self.handle_product_created(event)
    repository[event.product_id] = Dto.new(event.product_id, event.name, event.sku)
  end

  def self.handle_product_renamed(event)
    product = find(event.product_id)
    product.name = event.name
  end

  def self.handle_product_sku_modified(event)
    product = find(event.product_id)
    product.sku = event.sku
  end
end