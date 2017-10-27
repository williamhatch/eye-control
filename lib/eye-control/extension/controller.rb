require 'pry'
class Eye::Controller
  def set_opt_control(args)
    params = args[0]

    params[:host]     ||= "127.0.0.1"
    params[:port]     ||= 6379
    params[:db]       ||= 0

    params[:port] = params[:port].to_i
    params[:db]   = params[:db].to_i

    XLogger.info 'soc shit'
    start_control(params)
  end

  def start_control(config)
    @eye_control = ::Eye::RedisManager.supervise as: :actor, type: Actor, args: [config]
  end

  def stop_eye_control
    if @eye_control
      @eye_control.stop
      @eye_control = nil
    end
  end
end
