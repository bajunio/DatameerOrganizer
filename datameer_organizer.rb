=begin


TODO:
Add netstat to troubleshoot connections
Add `ps aux` ability



=end




require_relative 'datameer_organizer.properties.rb'

class DatameerOrganizer
  include DatameerOrganizerProperties

  attr_accessor :datameer_versions, :base_dir, :pid, :port_check

  def initialize
    @base_dir = DatameerOrganizerProperties.base_dir
    @datameer_versions = []
    @pid = pid
    @port_check = port_check
  end

  def collect_datameer_versions
    Dir.glob(base_dir + '/*').select do |path_to_datameer|
      datameer_versions << "/" + path_to_datameer.split('/')[-1]
    end
  end

  def start_datameer_instance (datameer_version, port)
    if port_available?(port)
      exec(base_dir + datameer_version + "/./bin/conductor.sh start")
    else
      puts "Sorry, port is in use."
    end
    collect_datameer_instance_info(port)
  end

  def stop_datameer_instance (datameer_version)
    exec(base_dir + datameer_version + "/./bin/conductor.sh stop")
  end

  def get_pid (process_name)
    pid = `pgrep #{process_name}`.strip
  end

  def process_running? (pid)
    begin
      Process.kill(0, Integer(pid))
      puts "#{pid} is alive!"
    rescue Errno::EPERM
      puts "#{pid} has escaped my control!";
    rescue Errno::ESRCH
      puts "#{pid} is deceased.";
    rescue
      puts "Odd; I couldn't check the status"
    end
  end

  def port_available? (port)
    `lsof -i :#{port}`.empty?
  end



  def collect_datameer_instance_info (port)
      info = `lsof -i :#{port}`.split(' ')
      port_check = info.include?("java" && "(LISTEN)")
      pid = info[10]
  end




end