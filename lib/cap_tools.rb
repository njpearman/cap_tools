puts "My Capistrano tools!"

current = File.dirname(File.expand_path(__FILE__))

Dir["#{current}/cap_tools/tasks/*rake"].each {|rake| load rake }
