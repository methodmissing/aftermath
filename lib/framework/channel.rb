# Dead simple in process pub/sub channel.
#

class Aftermath::Channel
  def initialize
    @subscribers = []
  end

  def subscribe(&b)
    @subscribers << b
  end

  def <<(o)
    @subscribers.each { |s| s.call(o) }
  end
  alias publish <<
end