require 'json'
require 'securerandom'

module Pando
  class Instance
    attr_reader :host, :port, :guid

    def initialize(options = {})
      @host = options[:host]
      @port = options[:port]
      @guid = options[:guid] || self.class.generate_guid

      fail ArgumentError, 'You must provide :host and :port' unless host && port
    end

    def self.deserialize(json)
      json_hash = ::JSON.parse(json)
      json_hash = ::Hash[ json_hash.map { |(k, v)| [k.to_sym, v] } ]
      self.new(json_hash)
    end

    def self.generate_guid
      "instance-#{::SecureRandom.uuid}"
    end

    def serialize
      {:host => host, :port => port, :guid => guid}.to_json
    end
  end
end
