# config valid only for current version of Capistrano
#lock "3.8.2"

set :application, "scrapator"
set :repo_url, "https://github.com/jeanfbrito/scrapator.git"

set :deploy_to, '/home/deploy/scrapator'

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

after "passenger:restart", "chmod_binaries"
before "deploy:migrate", "renew_jobs"
after 'deploy:finished', 'telegram:bot:poller:restart'

task :chmod_binaries do
  on roles(:all) do
    execute "chmod +x #{current_path}/bin/delayed_job"
    execute "chmod +x #{current_path}/bin/telegram_bot"
    execute "chmod +x #{current_path}/bin/telegram_bot_ctl"
    #execute "pkill -f telegram_bot"
  end
end

task :renew_jobs do
  on roles(:all) do
    execute "cd #{current_path} && RAILS_ENV=production $HOME/.rbenv/bin/rbenv exec bundle exec rake jobs:clear"
    execute "cd #{current_path} && RAILS_ENV=production $HOME/.rbenv/bin/rbenv exec bundle exec rake scrape:start"
    end
end

namespace :telegram do
  namespace :bot do
    namespace :poller do
      {
        start:         'start an instance of the application',
        stop:          'stop all instances of the application',
        restart:       'stop all instances and restart them afterwards',
        reload:        'send a SIGHUP to all instances of the application',
        # run:           'start the application and stay on top',
        zap:           'set the application to a stopped state',
        status:        'show status (PID) of application instances',
      }.each do |action, description|
        desc description
        task action do
          on roles(:app) do
            within current_path do
              with rails_env: fetch(:rails_env) do
                execute :bundle, :exec, 'bin/telegram_bot_ctl', action
              end
            end
          end
        end
      end
    end
  end
end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
