class Eye::Dsl::ConfigOpts      
  def enable_control(*args)
    @config[:control] = args

    # Eye::Controller.set_opt_eye_control(*args)
    @tlogger = Logger.new('/home/schaerli/Rails/yml_converter/foo.txt')
    @tlogger.info 'im here in the enable_eye_control'    

    
  end
end