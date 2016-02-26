set :stage, :production_cfi
set :rails_env, :production

server 'it-cfiprog.jmu.edu', port: 22, roles: [:app, :web, :db], primary: true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"

set :puma_workers, 3
set :puma_threads, [4, 16]
set :puma_control_app, true
