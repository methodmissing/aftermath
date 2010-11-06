require 'domain/values'

module Domain
  class << self
    attr_accessor :storage, :publisher

    def <<(command)
      @handler ||= CommandHandlers.new(repository)
      @handler << command
    end

    def repository
      @repository ||= Aftermath::DomainRepository.new(Aftermath::EventStore.new(storage, publisher))
    end

    def trace
      Aftermath.trace!
    end

    def subscribe(&b)
      publisher.subscribe(&b)
    end

    def publisher
      @publisher ||= Aftermath::Channel.new
    end
  end
end