class Values::Category < Struct.new(:id, :name, :description)
  ALL = {
    :coffee => new(:coffee, 'Coffee', '...'),
    :blends => new(:blends, 'Blends', '...'),
    :tea => new(:tea, 'Tea', '...'),
  }.freeze

  def to_s; id; end
end.freeze

module Kernel
  private
  def Category(c)
    Values::Category::ALL[(c.to_sym if c)] || raise(ArgumentError)
  end
end