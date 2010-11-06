module CommandHandlers::CategorizeProduct
  def handle_categorize_product(command)
    product = repository.find(command.product_id)
    product.categorize(command.category)
    repository.save(product)
  end
end