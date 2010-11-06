class Values::Rack < Struct.new(:id, :code, :capacity)
  ALL = {
    :A => new(:A, 'A', 100),
    :B => new(:B, 'B', 150),
    :C => new(:C, 'C', 80),
  }.freeze

  def to_s; id; end
end.freeze

module Kernel
  private
  def Rack(r)
    Values::Rack::ALL[(r.to_sym if r)] || raise(ArgumentError)
  end
end