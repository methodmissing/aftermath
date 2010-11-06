class Values::OrderStatus < Struct.new(:id, :name, :description)
  ALL = {
    :open => new(:open, 'Open', '...'),
    :shipped => new(:shipped, 'Shipped', '...'),
    :cancelled => new(:cancelled, 'Cancelled', '...'),
    :held => new(:held, 'Held', '...'),
  }.freeze

  def to_s; id; end
end.freeze

module Kernel
  private
  def OrderStatus(os)
    Values::OrderStatus::ALL[(os.to_sym if os)] || raise(ArgumentError)
  end
end