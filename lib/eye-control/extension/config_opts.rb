require_relative '../logger'

class Eye::Dsl::ConfigOpts
  create_options_methods([:control], Hash)

  def enable_control(*args)
	  XLogger.info 'ec shit'
    @config[:control] = args
  end
end
