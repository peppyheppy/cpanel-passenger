require 'optparse'
require 'ftools'
      
module CpanelPassenger
  class CLI
    def self.execute(stdout, arguments=[])

      options = {
        :username     => nil,
        :path     => nil
      }
      mandatory_options = %w( -u -p )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is wonderful because...

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--path=PATH", String,
                "The absolute path to your rails application root (ex: /home/username/blog)",
                "Default: ~") { |arg| options[:path] = arg }
        opts.on("-u", "--username=USERNAME", String, 
                "Your cpanel account username (ex: peppyheppy)") { |arg| options[:username] = arg.strip }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      username = options[:username]
      rails_app_path = options[:path]

      stdout.puts "* Setting up Rails app in Apache config for user"
      raise "Path is required!" unless File.directory?(rails_app_path) or File.directory?("#{rails_app_path}/public")
      raise "Script needed for overriding or appending vhost includes is not found, do you have cpanel installed?" unless File.exists?("/scripts/ensure_vhost_includes")
      
      stdout.puts "* Fetching info from httpd.conf"
      path_to_config = File.new("/usr/local/apache/conf/httpd.conf").readlines.grep(/userdata\/.*\/#{username}/).first.strip[/\/usr\/.*[*]/].chop + "rails.conf"

      stdout.puts "* Creating configs for #{username}"
      file = File.open(path_to_config,  "w+")
      file.write "# line added by cpanel passenger script\n"
      file.write "DocumentRoot #{rails_app_path}/public"
      file.close    

      stdout.puts "* Enabling the configs for #{username}"
      `/scripts/ensure_vhost_includes --user=#{username}`    

      stdout.puts "* Done. You can view the config changes in #{path_to_config}"

  end
end
