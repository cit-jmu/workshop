# config valid only for current version of Capistrano
lock '3.4.0'

server 'workshop.cit.jmu.edu', port: 22, roles: [:web, :app], primary: true

set :repo_url, 'git@github.com:cit-jmu/workshop.git'
set :user, 'deploy'
set :puma_threads, [4, 16]
set :puma_workers, 0

set :rbenv_ruby, File.read('.ruby-version').strip

# Don't change these unless you know what you're doing
set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :ssh_options, { forward_agent: true,
  user: fetch(:user), keys: %w(~/.ssh/id_rsa)}
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

## Defaults
# set :scm, :git
# set :branch, :master
# set :format, :pretty
# set :log_level, :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, fetch(:linked_files, []).push('.rbenv-vars')
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle',
  'public/system'
)

#namespace :puma do
#  desc 'Create directories for Puma pids, socket, and logs'
#  task :make_dirs do
#    on roles(:app) do
#      execute "mkdir #{shared_path}/log -p"
#      execute "mkdir #{shared_path}/public/system -p"
#      execute "mkdir #{shared_path}/tmp/sockets -p"
#      execute "mkdir #{shared_path}/tmp/pids -p"
#      execute "mkdir #{shared_path}/tmp/cache -p"
#    end
#  end
#
#  before :start, :make_dirs
#end

namespace :deploy do
  desc 'Make sure local git is in sync with remote'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end

  desc 'Initial deployment'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

### Below here are defaults from `cap install`

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# namespace :deploy do
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end