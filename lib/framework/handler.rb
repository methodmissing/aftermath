module Aftermath::Handler
  def handle(msg)
    handler = :"handle_#{msg.to_handler}"
    __send__ handler, msg if respond_to?(handler)
  end
  alias << handle
end