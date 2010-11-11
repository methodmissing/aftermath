module Aftermath::Handler
  def handle(msg)
    __send__ :"handle_#{msg.to_handler}", msg
  end
  alias << handle
end