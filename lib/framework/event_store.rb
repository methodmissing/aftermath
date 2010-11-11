# An Event Store for deltas (state changes) to Aggregates in our core domain.
#
# Implements the following contracts :
#
#   find #=> retrieves events / state changes for the aggregate, used for rebuilding to current
#            state
#
#   save #=> attempts to persist an aggregate with it's relevant changes as a single unit of
#            work.
#
#   subscribe #=> subscription hook for republished events (External Events)
#

require 'sqlite3'

class Aftermath::EventStore
  class AggregateNotFound < StandardError; end
  class ConcurrencyError < StandardError; end

  # For demonstrating an example Event Store schema
  #
  SCHEMA = %[CREATE TABLE events(
              aggregate_id GUID,
              aggregate_type VARCHAR,
              data BLOB,
              structural_version INTEGER,
              version INTEGER);
             CREATE TABLE aggregates(
              aggregate_id GUID,
              aggregate_type VARCHAR,
              structural_version INTEGER,
              version INTEGER);
            ]

  def initialize(storage, publisher)
    @storage, @publisher = storage, publisher
    create_schema unless schema_exists?
  end

  def trace
    @storage.trace{|sql| pp sql }
  end

  def find(aggregate_id)
    events = @storage.execute("SELECT aggregate_type, version, data FROM events WHERE aggregate_id = ? ORDER BY version", aggregate_id)
    raise AggregateNotFound if events.empty?
    events
  end

  # Aggregate persistence - stores the Aggregate along with any state changes.State changes
  # is republished to subscribers (most notably the read model) on success.We're generating
  # a SQL snippet and execute them in batch in a single transaction.
  #
  def save(aggregate_type, aggregate_id, events, expected_version = 0)
    sql, version = [], nil
    @storage.transaction do |s|
      unless version = s.get_first_value("SELECT version FROM aggregates WHERE aggregate_id = ?", aggregate_id)
        version = 0
        sql << "INSERT INTO aggregates(aggregate_id, aggregate_type, structural_version, version) VALUES ('#{aggregate_id}', '#{aggregate_type}', #{aggregate_type.version}, #{version})"
      end
      assert_expected_version(version, expected_version)
      events.each do |event|
        sql << "INSERT INTO events(aggregate_id, aggregate_type, data, structural_version, version) VALUES ('#{aggregate_id}', '#{aggregate_type}', '#{SQLite3::Blob.new(event.to_json)}', #{event.structural_version}, #{version += 1})"
      end
      sql << "UPDATE aggregates SET version = #{version} WHERE aggregate_id = '#{aggregate_id}'"
      s.execute_batch(sql.join(";\n"))
      # XXX within a transactional context, republishing stored events may still fail
      events.each{|e| publish(e) }
    end
    version
  end

  # Subscription for External (republished) Events
  #
  def subscribe(&b)
    @publisher.subscribe(&b)
  end

  private
  def assert_expected_version(version, expected)
    raise ConcurrencyError.new("Version #{expected} expected, got #{version}") if version != expected && expected != -1
  end

  def schema_exists?
    tables = @storage.get_first_value("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;") || []
    !(%w(aggregates events) & tables).empty?
  end

  def create_schema
    @storage.execute_batch(SCHEMA)
  end

  def publish(event)
    @publisher << event
  end
end