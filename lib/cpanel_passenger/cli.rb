require 'optparse'
require 'ftools'
      
module CpanelPassenger
  class CLI
    def self.execute(stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        :path     => '~'
      }
      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is wonderful because...

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--path=PATH", String,
                "This is a sample message.",
                "For multiple lines, add more strings.",
                "Default: ~") { |arg| options[:path] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      path = options[:path]

      # do stuff
      # get the user name
      print "Enter your account username (ex: peppyheppy): "
      username = gets.strip
      raise "Username is required!" if username.strip.nil?

      # get the path to the rails app's public dir
      print "Enter the name of the Rails app locatted in /home/#{username} (ex: blog in /home/#{username}/blog): "
      rails_app_path = "/home/#{username}/#{gets.strip}"
      raise "Path is required!" unless File.directory?(rails_app_path) or File.directory?("#{rails_app_path}/public")

      stdout.puts "Setting up Rails app in Apache config for user"
      if File.directory?("/home/#{username.strip}")
        if File.exists?("/scripts/ensure_vhost_includes")
          stdout.puts "Fetching info from httpd.conf"
          path_to_config = File.new("/usr/local/apache/conf/httpd.conf").readlines.grep(/userdata\/.*\/#{username}/).first.strip[/\/usr\/.*[*]/].chop + "rails.conf"

          stdout.puts "Creating configs for #{username}"
          file = File.open(path_to_config,  "w+")
          file.write "# line added by cpanel passenger script\n"
          file.write "DocumentRoot #{rails_app_path}/public"
          file.close    

          stdout.puts "Enabling the configs for #{username}"
          `/scripts/ensure_vhost_includes --user=#{username}`    

          stdout.puts "Done. You can view the config changes in #{path_to_config}"
        else
          raise "Script needed for overriding or appending vhost includes is not found, do you have cpanel installed?"
        end

      else
       raise "The user does not exist on the system."
      end
   
    end
  end
end