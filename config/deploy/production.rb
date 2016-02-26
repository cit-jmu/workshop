set :stage, :production
set :rails_env, :production

server 'workshop.cit.jmu.edu', port: 22, roles: [:web, :app, :db], primary: true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"

set :puma_workers, 3
set :puma_threads, [4, 16]
set :puma_control_app, true
