class Eye::Dsl::ConfigOpts      
  def enable_control(*args)
    @config[:control] = args
  end
end