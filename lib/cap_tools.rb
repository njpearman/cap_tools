puts "My Capistrano tools!"
load File.join(File.dirname(File.expand_path(__FILE__)), "./cap_tools/tasks/tasks.rake")
load File.join(File.dirname(File.expand_path(__FILE__)), "./cap_tools/tasks/foreman.rake")
