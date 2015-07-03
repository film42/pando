require 'rubygems'
require 'bundler'

Bundler.require(:default, :development, :test)

require 'pando'

RSpec.configure do |config|
  config.color = true
end
