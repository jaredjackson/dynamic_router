require "dynamic_router/version"
require "dynamic_router/class_methods"

module DynamicRouter
  def self.extended(receiver)
    receiver.extend ClassMethods
  end
end
