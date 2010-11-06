class Aftermath::Handler
  def initialize(repository)
    @repository = repository
  end

  def handle(msg)
    __send__ :"handle_#{msg.to_handler}", msg
  end
  alias << handle

  private
  def repository; @repository; end
end