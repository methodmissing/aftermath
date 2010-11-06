module CommandHandlers::RenameProduct
  def handle_rename_product(command)
    product = repository.find(command.product_id)
    product.rename(command.name)
    repository.save(product)
  end
end