module CommandHandlers::ModifyProductSku
  def handle_modify_product_sku(command)
    product = repository.find(command.product_id)
    product.modify_sku(command.sku)
    repository.save(product)
  end
end