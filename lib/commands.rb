module Commands
  def self.command(cmd)
    autoload cmd, "commands/#{cmd.to_s.to_underscore}"
    commands << cmd
  end

  def self.commands
    @commands ||= []
  end

  def self.assert
    commands.each{|c| Commands.const_get(c) }
  end

  command :AddCouponToCart
  command :AddProductToCart
  command :RemoveProductFromCart
  command :UpdateCartQuantity
  command :ClearCart
  command :CreateCart
  command :RemoveCouponFromCart

  command :CreateProduct
  command :ModifyProductSku
  command :CategorizeProduct
  command :RenameProduct

  command :AddInventory
  command :RelocateInventory
  command :RemoveInventory
  command :CreateInventory

  command :CreateOrder
  command :AddProductToOrder
  command :CancelOrder
  command :HoldOrder
  command :RemoveProductFromOrder
  command :ShipOrder
  command :UpdateOrderQuantity
end

module Kernel
  private
  def Command(cmd, params = nil)
    Commands.const_get(cmd).new(params)
  end
end