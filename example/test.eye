require 'eye-control'

Eye.config do
  enable_control :host => "127.0.0.1", :db => "1", :port => "6379"  #,, :readonly => true
end

Eye.application :app do
  process :process do
    start_command "sleep 100"
    daemonize true
    pid_file "/tmp/1.pid"
  end
end
