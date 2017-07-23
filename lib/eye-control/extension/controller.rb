class Eye::Controller
  def set_opt_control(args)
    @tlogger = Logger.new('foo.txt')
    @tlogger.info 'im here in the set_opt_eye_control'
    @tlogger.info "#{args.inspect}"

    params = args[0]

    params[:host]     ||= "127.0.0.1"
    params[:port]     ||= 6379
    params[:db]       ||= 0

    params[:port] = params[:port].to_i
    params[:db]   = params[:db].to_i

    @tlogger.info "#{params.inspect}"

    start_control(params)
  end

  def start_control(config)
    if @eye_control && @eye_control.actors.first.config != config
      stop_eye_control
    end

    if @eye_control.nil?
      @tlogger.info "in the start_eye_control"
    # @eye_control = ::Eye::RedisManager.supervise(config)
    # @eye_control = ::Eye::RedisManager.supervise as: :actor, type: Actor, args: [config]
      Celluloid::Actor[:eye_redis_manager] = ::Eye::RedisManager.supervise(config)

      # @eye_control = ::Eye::RedisManager.supervise as: :my_actor, args: [config]

    end
  end

  def stop_eye_control
    if @eye_control
      @eye_control.stop
      @eye_control = nil
    end
  end
end