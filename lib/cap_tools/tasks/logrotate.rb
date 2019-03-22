namespace :logrotate do
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

  task :create do
    on roles(:app) do
      log_config_file = "/etc/logrotate.d/#{fetch(:application)}"
			if test("[ -f #{log_config_file} ]")
				puts 'Found logrotate config'
				execute 'cat', log_config_file
			else
				puts 'Creating logrotate config'
				upload! "config/#{fetch(:application)}.logrotate", 
				execute 'sudo', 'mv', "/tmp/#{fetch(:application)}", '/etc/logrotate.d/'
      end
    end
  end
end


