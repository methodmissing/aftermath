# A Repository interface for use in our core Domain.
#

class Aftermath::Repository
  def initialize(storage)
    @storage = storage
  end

  def find(uuid)
    raise NoMethodError, "Repositories expected to implement a #find(uuid) contract!"
  end

  private
  def trace
    yield if Aftermath.tracing?
  end
end