require 'pando/version'

require 'pando/errors'
require 'pando/configuration'
require 'pando/instance'
require 'pando/service_directory'

module Pando
  def self.configuration
    @configuration ||= ::Pando::Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class << self
    alias_method :config, :configuration
  end

  # Initialize config object
  config
end
