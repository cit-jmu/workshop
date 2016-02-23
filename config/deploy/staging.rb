set :stage, :staging

server 'it-cfiprog.jmu.edu', port: 22, roles: [:web, :app, :db], primary: true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}_staging"

set :puma_access_log, "#{shared_path}/log/puma.access.log"
set :puma_error_log, "#{shared_path}/log/puma.error.log"

set :puma_workers, 0
set :puma_threads, [4, 16]
set :puma_control_app, true
