class Eye::Dsl::ConfigOpts
  create_options_methods([:eye_control], Hash)

  def enable_control(*args)
    @config[:control] = args
  end
end
