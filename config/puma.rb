# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 5

preload_app!

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/../shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
#bind "unix://#{app_dir}/tmp/puma/sock"
bind "tcp://127.0.0.1:4000"

# Logging
# stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/tmp/puma/pid"
state_path "#{app_dir}/tmp/puma/state"
activate_control_app "unix://#{app_dir}/tmp/puma/ctl.sock"

# on_worker_boot do
#   require "active_record"
#   ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
#   ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
# end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
