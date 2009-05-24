require 'optparse'
require 'ftools'
require 'fileutils'
      
module CpanelPassenger
  class CLI

    def self.execute(stdout, arguments=[])

      options = {
        :username     => nil,
        :path     => nil,
        :maxpoolsize => nil,
        :poolidletime => nil,
        :showcurrentconfig => nil,
        :miscconfig => nil
      }
      mandatory_options = %w( username path )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is wonderful because...

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-c", "--show-current-config",
                "Show the current config for an account; requires -u and -p") { |arg| options[:showcurrentconfig] = true }
        opts.on("-p", "--path=PATH", String,
                "The absolute path to your rails application root (ex: /home/username/blog/current)") { |arg| options[:path] = arg }
        opts.on("-u", "--username=USERNAME", String, 
                "Your cpanel account username (ex: peppyhep)") { |arg| options[:username] = arg.strip }
        opts.on("-d", "--domain=domain", String, 
                "The domain for this username (ex: peppyheppy.com)") { |arg| options[:domain] = arg.strip }
        opts.on("-s", "--max-pool-size=SIZE", String, 
                "Value for PassengerMaxPoolSize which is used for setting", 
                "the max number of application instances") { |arg| options[:maxpoolsize] = arg.strip }
        opts.on("-t", "--pool-idle-time=TIME", String, 
                "Value for PassengerPoolIdleTime which sets the idle time", 
                "for an application instance before it shuts down") { |arg| options[:poolidletime] = arg.strip }
        opts.on("-m", "--misc-config='OPV V,OPT V'", String, 
                "List of comma-delimited Passenger configuration parameters with values;",
                "don't forget to to wrap multiple arguments in quotes.",
                "(PassengerParam1 1,PassengerParam2 99)") { |arg| options[:miscconfig] = arg.split(',').map { |config| "#{config.strip}\n" } unless arg.nil? }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      username = options[:username]
      rails_app_path = options[:path]
      apache_config_root = '/usr/local/apache/conf'
      apache_userdata_config_root = "#{apache_config_root}/userdata/std/2"

      stdout.puts "* Setting up Rails app in Apache config for user"
      raise "Path is required!" unless File.directory?(rails_app_path) or File.directory?("#{rails_app_path}/public")
      raise "Script needed for overriding or appending vhost includes is not found, do you have cpanel installed?" unless File.exists?("/scripts/ensure_vhost_includes")
                       
      unless File.directory?("#{apache_userdata_config_root}/#{username}")
        raise "Apache is not yet configured for your virtual host configurations... please provide the domain (-d/--domain)" unless options[:domain]
        stdout.puts "* Making required apache config dirs."
        config_path = "#{apache_userdata_config_root}/#{username}/#{options[:domain]}"
        FileUtils::mkdir_p(config_path)  
        path_to_config = config_path + "/rails.conf"
      end      

      stdout.puts "* Fetching info from httpd.conf"
      path_to_config ||= File.new("/usr/local/apache/conf/httpd.conf").readlines.grep(/userdata\/.*\/#{username}/).first.strip[/\/usr\/.*[*]/].chop + "rails.conf"

      unless options[:showcurrentconfig]
        stdout.puts "* Creating configs for #{username}"
        file = File.open(path_to_config,  "w+")
        file.write "# line added by cpanel passenger script\n"
        file.write "DocumentRoot #{rails_app_path}/public\n"
        # optionsal parameters
        unless options[:maxpoolsize].nil?
          file.write "PassengerMaxPoolSize #{options[:maxpoolsize]}\n" if options[:maxpoolsize].to_i > 0
        end
        unless options[:poolidletime].nil?
          file.write "PassengerPoolIdleTime #{options[:poolidletime]}\n" if options[:poolidletime].to_i > 0
        end
        # misc parameters
        unless options[:miscconfig].nil? or options[:miscconfig].size == 0
          options[:miscconfig].each { |config| file.write("#{config}\n") }
        end
        file.close
        stdout.puts "* Enabling the configs for #{username}"
        `/scripts/ensure_vhost_includes --user=#{username}`

        stdout.puts "* Done. You can view the config changes in #{path_to_config}"
      else
        if File.exists?(path_to_config)
          puts "---- CONFIG ----"
          File.new(path_to_config).each { |line| puts line }
          puts "---- EOF CONFIG ----"          
        else
          puts "Passenger is not configured for this username."
        end
      end
    end
  end
end
