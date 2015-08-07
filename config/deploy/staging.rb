set :stage, :staging

server 'workshop.cit.jmu.edu', port: 22, roles: [:web, :app, :db], primary: true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}_staging"

