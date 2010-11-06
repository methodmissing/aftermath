module CommandHandlers::CreateProduct
  def handle_create_product(command)
    product = Aggregates::Product.new :uuid => command.product_id,
                                      :name => command.name,
                                      :sku => command.sku,
                                      :category => command.category
    repository.save(product, -1)
  end
end