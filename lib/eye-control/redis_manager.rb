class Eye::RedisManager
  include Celluloid

  attr_accessor :config

  def initialize(config)
    @tlogger = Logger.new('/home/schaerli/Rails/yml_converter/foo.txt')

    @tlogger.info 'im here in the redis manager initialize'
    @tlogger.info "config comes = #{config.inspect}"

    @config = config

    self.async.init_redis
    # self.async.init_subscriptions
    
    every(5.seconds) do 
      @tlogger.info "broadcast_states"
      broadcast_states 
    end
  end

  def init_redis
    @tlogger = Logger.new('/home/schaerli/Rails/yml_converter/foo.txt')
    @tlogger.info 'im here in the redis manager init_redis'
    @tlogger.info "log #{@config.inspect}"

    # @redis = ::Redis.new(:host => "192.168.1.77", :port => 6379, :db => 1, :driver => :celluloid)
    @redis = ::Redis.new(:host => @config[:host], :port => @config[:port], :db => @config[:db], :driver => :celluloid)
    @redis_sub = ::Redis.new(:host => @config[:host], :port => @config[:port], :db => @config[:db], :driver => :celluloid)

    # @redis_sub.psubscribe("eye:command:*") do |on|
    #   @tlogger.info "inside psubscribe #{on.inspect}"
    #   on.pmessage do |pattern, channel, msg|
    #     begin
    #       evt = JSON.parse(msg)
    #     rescue
    #       warn "Unable to parse incoming Redis message"
    #       next
    #     end

    #     next unless evt["host"] == Eye::Local.host
    #     next unless process = Eye::Control.process_by_full_name(evt["full_name"])

    #     if evt["event"] == "process:start" 
    #       info "Starting #{process.full_name}"
    #       process.send_command(:start)
    #     elsif evt["event"] == "process:stop" 
    #       info "Stopping #{process.full_name}"
    #       process.send_command(:stop)
    #     elsif evt["event"] == "process:restart"
    #       info "Restarting #{process.full_name}"
    #       process.send_command(:restart)
    #     end
    #   end
    # end

    # $redis.subscribe('rubyonrails', 'ruby-lang') do |on|
    #   on.message do |channel, msg|
    #     data = JSON.parse(msg)
    #     puts "##{channel} - [#{data['user']}]: #{data['msg']}"
    #   end
  end

  # def init_subscriptions
  #   @tlogger.info 'init_subscriptions'
  #   @subscription = @redis.subscribe("process:state", :broadcast_state)
  # end

  def broadcast_states
    @tlogger.info 'broadcast_state'
    @client = ::Eye::Client.new(::Eye::Local.socket_path)
    client.execute(command: :info_data)
    client.execute(command: :short_data)
    
    controller = ::Eye::Controller.new
    @tlogger.info "all processes => #{controller.all_processes.inspect}"
    @tlogger.info "uii => #{controller}"
    @tlogger.info "uii => #{controller.all_processes}"
    @tlogger.info "uii => #{controller.all_groups}"
    @tlogger.info "uii => #{controller.short_tree}"

    controller.all_processes.each do |p| 
      @tlogger.info "broadcast_state => #{p.inspect}"
      broadcast_state(nil, p) 
    end
  end

  def broadcast_state(topic, process)
    process_state = process.state_hash

    # @redis.hset("eye:processes", process.state_key, process_state.to_json)
    @redis.publish("eye:process:state", process_state.to_json)
  end

end