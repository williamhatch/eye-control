class Eye::RedisManager
  include Celluloid

  attr_accessor :config

  def initialize(config)
    @config = config
    
    async.init_redis
    
    every(5.seconds) do 
      async.broadcast_states
    end
  end

  def init_redis
    @tlogger = Logger.new('/home/schaerli/Rails/yml_converter/foo.txt')

    @redis = ::Redis.new(:host => @config[:host], :port => @config[:port], :db => @config[:db], :driver => :celluloid)
    @redis_sub = ::Redis.new(:host => @config[:host], :port => @config[:port], :db => @config[:db], :driver => :celluloid, :timeout => 0)  

    Thread.new do
      @redis_sub.psubscribe("eye:command:*") do |on|
        on.pmessage do |pattern, channel, msg|
          begin
            evt = JSON.parse(msg)
          rescue
            warn "Unable to parse incoming Redis message"
            next
          end

          next unless evt["host"] == Eye::Local.host
          next unless process = Eye::Control.process_by_full_name(evt["full_name"])

          if evt["event"] == "process:start" 
            info "Starting #{process.full_name}"
            process.start_process
          elsif evt["event"] == "process:stop" 
            info "Stopping #{process.full_name}"
            process.stop_process
          elsif evt["event"] == "process:restart"
            info "Restarting #{process.full_name}"
            process.restart_process
          end
        end
      end
    end
  end

  def broadcast_states
    Eye::Control.all_processes.each{|p| broadcast_state(nil, p) }
  end

  def broadcast_state(topic, process)
    process_state = process.state_hash

    @redis.hset("eye:processes", process.state_key, process_state.to_json)
    @redis.publish("eye:process:state", process_state.to_json)
  end

end