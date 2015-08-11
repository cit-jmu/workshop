# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'workshop'
set :repo_url, 'git@github.com:cit-jmu/workshop.git'
set :user, 'deploy'

set :rbenv_ruby, File.read('.ruby-version').strip

set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
set :ssh_options, {
  forward_agent: true,
  user: fetch(:user),
  keys: %w(~/.ssh/id_rsa)
}

## Linked Files & Directories (Default None):
set :linked_files, fetch(:linked_files, []).push('.rbenv-vars')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache',
                                               'tmp/sockets', 'public/system')

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

  after 'deploy:updated', 'newrelic:notice_deployment'
end
