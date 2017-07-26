require 'eye-control'

Eye.config do
  enable_control :host => "192.168.1.5", :db => "1", :port => "6379"
end

Eye.application :app do
  process :process do
    start_command "sleep 100"
    daemonize true
    pid_file "/tmp/1.pid"
  end
end