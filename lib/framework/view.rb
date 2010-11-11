class Aftermath::View
  extend Aftermath::Handler

  def self.repository=(rep)
    @repository = rep
  end

  def self.repository
    @repository ||= {}
  end

  def self.find(uuid)
    repository[uuid]
  end

  def self.filter(*args)
    repository.values
  end
end