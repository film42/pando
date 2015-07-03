Pando
=====

Pando is a cross-platform zookeeper powered generic service directory. Pando uses a hierarchy of hierarchacal design to allow for access across environments.

Here's an example of Pando's topology:

```
s1.sand
       \
        services          instance-:guid
                \        /
                 resource
                         \
                          instance-:guid

```

The topology reads like the following: an environment has a services directory, a service is given the name of its resource (ex: Users, Things, etc) and each resource is ephemeral instinaces. Ephemeral instances are the bread and butter of Pando. When a new application announces resouce instances to the network (starts up), it will only be available for as long as the application is connected to zookeeper (running). As soon as the connection to zookeeper is terminated, so do all of the instances linked to the application.

### Usage

#### Configuration

You can configure Pando by doing the following:

```ruby
::Pando.configure do |config|
  config.host = 'localhost'
  config.port = 2181
  config.environment = 'default'
end
```

#### Announcing

To announce to the network, create an instance and announce it for a given resource.

```ruby
instance = ::Pando::Instance.new(:host => 'probably.localhost', :port => '43000')
service_directory = ::Pando::ServiceDirectory.new
service_directory.announce(:resource => :users, :instances => [instance])
```

This will setup a connection to zookeeper and will add your instance to the service directory.

#### Connecting

Once your service directory is created, another application probably wants to access it. To do so, you can grab an instance for a given resource from Pando.

```ruby
service_directory = ::Pando::ServiceDirectory.new
instance = service_directory.instance_for(:users)

puts instance.port #=> 43000
puts instance.host #=> "probably.localhost"
```

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'pando'
```

Or install it yourself as:

    $ gem install pando


### Disclaimer

This is very much alpha and the design needs to be refined a lot. This is currently in MVP stage, and should not be used in production.

### Contributing

1. Fork it ( https://github.com/film42/pando/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
