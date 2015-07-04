require 'pando'
require 'socket'

##
# Client
#
def get_instance
  service_directory = ::Pando::ServiceDirectory.new
  service_directory.instance_for(:servers)
rescue ::Pando::NoInstancesAvailableError
  nil
end

puts "Client are starting."

3.times.map do |n|
  sleep 1 until get_instance
  instance = get_instance

  puts "Client request #{n + 1} is starting at port #{instance.port}."

  socket = ::TCPSocket.new(instance.host, instance.port)
  socket.write("I'm sending #{n + 1}")
  reply, _ = socket.recvfrom(1000)
  puts reply
  socket.close
end

puts "All client request finished!"
