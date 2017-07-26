Eye Control
===

A plugin for [Eye](http://github.com/kostya/eye) that provides centralized process monitoring and management. The GUI component is located at http://github.com/normelton/eye-control-gui.

### Eye Configuration

Each Eye server will report its state to a centralized [Redis](http://redis.io) Redis server. This must be configured on each Eye server:

```ruby
Eye.config do
  enable_control :host => "192.168.1.5", :db => "1", :port => "6379"
end
```

### Security

Right now, there are no security measures in place. Ensure that only legitimate clients can connect to your Eye Control and Redis servers.
