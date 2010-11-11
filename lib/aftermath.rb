require 'bundler'
Bundler.setup

require 'pp'
require 'securerandom'
require 'framework/core'

module Aftermath
  def self.component(c)
    autoload c, "framework/#{c.to_s.to_underscore}"
  end

  def self.trace!
    @tracing = true
  end

  def self.no_tracing!
    @tracing = false
  end

  def self.tracing?
    @tracing
  end

  component :Aggregate
  component :Channel
  component :Command
  component :Event
  component :Repository
  component :DomainRepository
  component :EventStore
  component :Message
  component :Handler
  component :Serializable
  component :View
  component :Domain

  # value added
  component :SnapShotter

  def self.uuid
    SecureRandom.hex
  end

  require 'domain'
  require 'aggregates'
  require 'events'
  require 'commands'
  require 'command_handlers'
  require 'reporting'
end