require 'aftermath'
Bundler.require :test
require 'sqlite3'

Events.assert
Commands.assert
Aggregates.assert
Reporting.boot

require File.expand_path('fixtures.rb', 'test')

class Test::Unit::TestCase
  def assert_events(sink, *events)
    expected = sink.to_a.map{|e| event_expectation(e) }
    assert_equal expected, events, "Expected events #{expected.join(', ')}, got #{sink.to_a.join(', ')}"
  end
  alias assert_changes assert_events

  def assert_no_events(agg)
    events = agg.changes.map{|e| event_expectation(e) }
    assert agg.changes.empty?, "Expected no events, got #{events.join(', ')}"
  end
  alias assert_no_changes assert_no_events

  def event_store(db = ":memory:", publisher = Aftermath::Channel.new)
    Aftermath::EventStore.new(SQLite3::Database.new(db), publisher)
  end

  def domain_repository(store = nil, db = ":memory:", publisher = Aftermath::Channel.new)
    Aftermath::DomainRepository.new(store || event_store(db, publisher))
  end

  private
  def event_expectation(e)
    e.class.name =~ /(?:[:]{2})?([a-zA-Z]*)$/
    $1.to_sym
  end
end

module AggregateTest
  attr_reader :queue
  def setup
    Domain.storage = SQLite3::Database.new(':memory:')
    @queue = []
    Domain.subscribe{|e| queue << e }
  end

  def uuid
    @uuid ||= Aftermath.uuid
  end

  def assert_published(*events)
    assert_events queue, *events
  end
end

module ReportingTest
  def self.included(klass)
    klass.class_eval do
      def setup; Reporting.views.each{|v| v.repository.clear }; end
    end
  end

  def uuid
    @uuid ||= Aftermath.uuid
  end  
end