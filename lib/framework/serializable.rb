# A serialization interface that saves to and reconstitutes from JSON using the memento pattern
# in favor of native language serialization.Notice that we don't do any type coercion to not
# detract towards technical details.
#

require 'yajl'

module Aftermath::Serializable
  module Dsl
    attr_writer :version
    def reconstitute(json)
      h = Yajl::Parser.parse(json, :symbolize_keys => true)
      o = eval(h.delete(:__name__)).new
      o.reconstitute(h)
    end

    def member(name, type = nil)
      _members[name] = type # for type info
      attr_accessor name
    end

    def property(name, type = nil)
      _members[name] = type # for type info
    end

    def members
      _members.keys
    end

    def version
      @version ||= 1
    end

    private
    def _members
      @_members ||= {}
    end
  end

  def initialize(data = nil)
    yield self if block_given?
    reconstitute(data) if Hash === data
  end

  def to_hash
    hsh = {:__name__ => self.class.name}
    members.each{|m| hsh[m] = instance_variable_get(:"@#{m}")}
    hsh
  end

  def to_json
    Yajl::Encoder.encode(to_hash)
  end

  def structural_version
    self.class.version
  end

  def reconstitute(data)
    unless (ex = (data.keys - members)).empty?
      raise NoMethodError.new("Unsupported contracts #{ex.inspect}")
    end
    data.each{|k,v| instance_variable_set(:"@#{k}", v) }
    self
  end

  def inspect
    PP.pp(to_hash, '')
  end

  private
  def members
    self.class.members
  end
end