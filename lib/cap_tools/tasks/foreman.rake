namespace :foreman do
  desc "Installs foreman"
  task :install do
    on roles(:app) do
      rbenv_exec = "#{fetch(:rbenv_path)}/bin/rbenv exec".split
      execute rbenv_exec + ['gem', 'install', 'foreman']
    end
  end

  desc "Export the Procfile to Ubuntu's systemd scripts"
  task :export do
    on roles(:app) do |app|
      within current_path do
        rbenv_exec = "#{fetch(:rbenv_path)}/bin/rbenv exec".split

        foreman_export = %w(foreman export)

        arguments = [
          "systemd", "/etc/systemd/system/",
          "-a", fetch(:application),
          "-u", app.user,
          "-l", "/var/#{fetch(:application)}/log",
          "-d", current_path
        ]

        sudo *(rbenv_exec + foreman_export + arguments)
        sudo 'mv', "/etc/systemd/system/#{fetch(:application)}-web\\@.service", "/etc/systemd/system/#{fetch(:application)}-web.service"
        # do the daemon reloading thing
        sudo '/bin/systemctl', 'daemon-reload'
      end
    end
  end

  desc "Start the application services"
  task :start do
    on roles(:app) do
      sudo '/bin/systemctl', 'start', "#{fetch(:application)}-web"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      sudo '/bin/systemctl', 'stop', "#{fetch(:application)}-web"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      sudo '/bin/systemctl', 'restart', "#{fetch(:application)}-web"
    end
  end

  desc 'Generates a default Rails Procfile file for foreman'
  task :generate do
    next if File.exist? 'Procfile'

    puts "Creating new Procfile"
    File.open 'Procfile', 'w' do |f|
      f << "web: bin/bundle exec puma -e production -C #{File.join shared_path, 'puma.rb'}\n"
    end
  end
end


