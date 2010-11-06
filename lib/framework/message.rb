module Aftermath::Message
  include Aftermath::Serializable
  def self.included(klass)
    klass.instance_eval do
      def to_handler
        @to_handler ||= name.split('::').pop.to_underscore
      end
      extend Aftermath::Serializable::Dsl

      def reconstitute(json, version = 0)
        m = super(json)
        m.instance_variable_set(:@__version__, version)
        m
      end
    end
  end

  def version
    @__version__
  end

  def to_handler
    self.class.to_handler
  end

  def inspect
    "#{self.class}(#{to_hash.reject!{|k,v| k == :__name__ }.inspect})"
  end
end