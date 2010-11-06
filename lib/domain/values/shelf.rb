class Values::Shelf < Struct.new(:id, :code, :capacity)
  ALL = {
    :X => new(:X, 'X', 10),
    :Y => new(:Y, 'Y', 15),
    :Z => new(:Z, 'Z', 20),
  }.freeze

  def to_s; id; end
end.freeze

module Kernel
  private
  def Shelf(s)
    Values::Shelf::ALL[(s.to_sym if s)] || raise(ArgumentError)
  end
end