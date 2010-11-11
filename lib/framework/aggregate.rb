# An Aggregate is an instance of a process and usually wraps a few Entities.
# Always a single unit of work - a transactional or consistency boundary that represents
# a task - it either fails or succeeds.
#
# Example:
#
#  A Shopping Cart aggregate is responsible for managing Cart Items.
#
#  AddProductToCart -> Cart -> ProductAddedToCart
#
#  We'd always manipulate Cart Items via a Cart.A Cart Item also don't have a unique identity
#  outside it's Cart boundary, whilst a Cart would have an identity within the application /
# system.
#

class Aftermath::Aggregate
  include Aftermath::Serializable
  extend Aftermath::Serializable::Dsl

  class << self
    attr_accessor :snapshot_threshold

    def inherited(klass)
      klass.property :uuid
    end

    def rebuild(events)
      new.rebuild(events)
    end
  end

  def rebuild(events)
    events.each{|e| apply(e, false) }
    self
  end

  def apply(event, diff = true)
    __send__ :"apply_#{event.to_handler}", event
    if diff
      changes << event
    else
      @__version__ = event.version
    end
  end

  def commit
    changes.clear
  end

  def uuid
    @uuid ||= Aftermath.uuid
  end

  def version
    @__version__ ||= 0
  end

  def changes
    @changes ||= []
  end
  alias to_a changes
end