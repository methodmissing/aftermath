# Command and Event handler interface.This is really fugly in Ruby as we have to rely on 
# duck typing due to a lack of first class type support.
#

module Aftermath::Handler
  def handle(msg)
    handler = :"handle_#{msg.to_handler}"
    __send__ handler, msg if respond_to?(handler)
  end
  alias << handle
end