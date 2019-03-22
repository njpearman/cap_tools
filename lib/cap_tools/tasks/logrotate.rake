namespace :logrotate do
  desc 'Displays logrotate status for current app'
  task :status do
    on roles(:app) do
      log_config_file = "/etc/logrotate.d/#{fetch(:application)}"
      execute 'ls', '/etc/logrotate.d/*'
			if test("[ -f #{log_config_file} ]")
				puts 'Found logrotate config'
				execute 'cat', log_config_file
			else
				puts 'No logrotate config found'
			end
      execute :cat, '/var/lib/logrotate/status'
    end
  end

  desc 'Creates logrotate config for current app'
  task :create do
    on roles(:app) do
      log_config_file = "/etc/logrotate.d/#{fetch(:application)}"
			if test("[ -f #{log_config_file} ]")
				puts 'Found logrotate config'
				execute 'cat', log_config_file
			else
        temp_location = "/tmp/#{fetch(:application)}"
				puts 'Creating logrotate config'
				upload! "config/#{fetch(:application)}.logrotate", temp_location
				sudo 'mv', temp_location, '/etc/logrotate.d/'
      end
    end
  end
end


