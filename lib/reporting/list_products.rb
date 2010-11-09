class Reporting::ListProducts < Aftermath::Handler
  class Dto < Struct.new(:product_id, :name, :sku)
  end

  def find(uuid)
    repository[uuid]
  end

  def list
    repository.values
  end

  private
  def handle_product_created(event)
    repository[event.product_id] = Dto.new(event.product_id, event.name, event.sku)
  end

  def handle_product_renamed(event)
    product = find(event.product_id)
    product.name = event.name
  end

  def handle_product_sku_modified(event)
    product = find(event.product_id)
    product.sku = event.sku
  end
end