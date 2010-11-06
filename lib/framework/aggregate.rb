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