class Eye::Controller
  def set_opt_control(args)
    params = args[0]

    params[:host]     ||= "127.0.0.1"
    params[:port]     ||= 6379
    params[:db]       ||= 0

    params[:port] = params[:port].to_i
    params[:db]   = params[:db].to_i

    start_control(params)
  end

  def start_control(config)
    if @eye_control
      stop_eye_control
    end

    if @eye_control.nil?
      @eye_control = ::Eye::RedisManager.supervise as: :actor, type: Actor, args: [config]
    end
  end

  def stop_eye_control
    if @eye_control
      @eye_control.stop
      @eye_control = nil
    end
  end
end