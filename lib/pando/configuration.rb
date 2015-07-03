module Pando
  class Configuration
    attr_accessor :host, :port, :resource, :environment

    def initialize
      self.host = 'localhost'
      self.port = 2181
      self.environment = 'default'
    end
  end
end
