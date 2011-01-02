require 'yaml'
require 'optparse'
require 'ostruct'
require 'logger' 
require 'fileutils'

class MyDeamon
  attr_accessor :action
  def initialize
    @config_file = "testConfig.yml"
    @environment = "test"
    @action      = "start"
    #Read the Basic data from the paramseter
    OptionParser.new do |opts|
      opts.banner = "Usage: exampleDaemon.rb [@options]"
      
      opts.on("-c", "--config FILE", "config file") do |v|
        @config_file = v
      end

      opts.on("-e", "--environment ENV", [:development, :test , :prod], "Select environment (development, test, prod") do |env|
        @environment = env
      end
      
      opts.on("-a", "--action start || stop") do |a|
        @action = a
      end
    end.parse!

      #Now get the Rest from the config - File
      @configData = YAML.load_file(File.join(File.dirname(__FILE__), @config_file))[@environment.to_s]

      #example loads from config File#
      @urls       =  @configData['urls']
      @logFile    =  @configData['logFile'][0]
      @log = Logger.new(@logFile)
      @log.level=Logger::DEBUG
      @run_condition = true
      @pid_file = @configData['pidFile'][0]
      puts(@action)
      puts(@urls)
      puts(@logFile)
      puts(@pid_file)
  end



  def start_daemon
    if File.exist?(@pid_file) then
      @log.error "Process already running. If it`s not - remove the pid file"
      exit
    end
    begin
      f=File.new(@pid_file,"w")
      f.write Process.pid
      f.close
    rescue Errno::EACCES
      @log.error("Cannot create PID file. Check the permissions and try again!")
      exit
    end
    @run_condition = true
    doIt 
  end


  def stop_daemon
    if File.exist?(@pid_file) then
      FileUtils.rm(@pid_file)
      @run_condition = false
    else
      puts("No pid-File " + @pid_file)
    end
  end


  def check_runcondition
    if File.exist?(@pid_file) then
      @run_condition = true
      return true
    else
      @run_condition = false
      return false
    end
  end

  def doIt
    while check_runcondition
      puts "Doing something, which need some time"
      sleep 5
      check_runcondition
    end

  end

end

d = MyDeamon.new
if d.action == "start" then
 d.start_daemon
end

if d.action == "stop" then
  d.stop_daemon
end

