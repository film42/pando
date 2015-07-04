require 'zk'

module Pando
  class ServiceDirectory
    class << self
      attr_accessor :client
    end

    attr_reader :host, :port, :environment

    def initialize(options = {})
      @environment = options[:environment] || ::Pando.config.environment

      unless  environment
        fail ArgumentError, 'You must provide an :environment'
      end
    end

    def announce(params = {})
      resource = params[:resource]
      instances = params[:instances]

      fail ArgumentError, 'Instances must be an array' unless instances.respond_to?(:empty?)

      unless resource && instances && !instances.empty?
        fail ArgumentError, 'You must provide :resource and non-empty :instances'
      end

      add_resource(resource)

      instances.each do |instance|
        create_instance(resource, instance)
      end
    end

    def take_down(resource, instance)
      client.rm_rf("#{base_path}/#{resource}/#{instance.guid}")
    end

    def base_path
      "/#{environment}/services"
    end

    def self.client
      # Singleton client
      @client ||= ::ZK.new("#{::Pando.config.host}:#{::Pando.config.port}")
    end

    def client
      # Alias
      self.class.client
    end

    def instance_for(resource)
      fail ArgumentError, 'You must provide a :resource' unless resource

      resource_path = "#{base_path}/#{resource}"
      children = client.children(resource_path)

      if children.empty?
        fail ::Pando::NoInstancesAvailableError, "No instances for #{resource_path}"
      end

      random_instance_guid = children.sample
      data, _ = client.get("#{resource_path}/#{random_instance_guid}")
      ::Pando::Instance.deserialize(data)
    end

  private

    def add_resource(resource)
      # Create a fixed path that will persist
      client.mkdir_p("#{base_path}/#{resource}")
    end

    def create_instance(resource, instance)
      instance_path = "#{base_path}/#{resource}/#{instance.guid}"

      # Using ephemeral, the instance is destroyed when the connection to
      # zookeeper is terminated
      client.create(instance_path, instance.serialize, :ephemeral => true)
    end
  end
end
