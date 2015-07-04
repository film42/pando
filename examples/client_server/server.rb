require 'pando'
require 'socket'

##
# Server
#
service_directory = ::Pando::ServiceDirectory.new

n = ARGV.first

puts "Starting server #{n}..."

instance = ::Pando::Instance.new(:host => 'localhost', :port => rand(4000..5000))
service_directory.announce(:resource => :servers, :instances => [instance])
puts "Server #{n} listening on port #{instance.port}."

server = ::TCPServer.new(instance.port)
client = server.accept

service_directory.take_down(:servers, instance)

message, _ = client.recvfrom(1000)
client.write("Reply '#{message}' from server #{instance.port}")
client.close

puts "Server completed its work!"
