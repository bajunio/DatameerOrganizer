=begin


TODO:
Add netstat to troubleshoot connections
Add `ps aux` ability



=end




require_relative 'datameer_organizer.properties.rb'

class DatameerOrganizer
  include DatameerOrganizerProperties

  attr_reader :datameer_versions, :base_dir, :pid, :port_check, :port

  def initialize
    @base_dir = DatameerOrganizerProperties.base_dir
    @port = DatameerOrganizerProperties.default_port
    @datameer_versions = []
    @pid = pid
    @port_check = false
  end

  # Collect Datameer Version / Instance Info
  # ======================================================================

  def collect_datameer_versions
    Dir.glob(base_dir + '/*').select do |path_to_datameer|
      datameer_versions << "/" + path_to_datameer.split('/')[-1]
    end
  end

  def collect_datameer_instance_info (port)
    info = `lsof -i :#{port}`.split(' ')
    port_check = info.include?("java" && "(LISTEN)")
    pid = info[10]
  end

  # Datameer Instance Start / Stop
  # ======================================================================

  def start_datameer_instance (datameer_version, port)
    if port_available?(port)
      `base_dir + datameer_version + "/./bin/conductor.sh start")`
      collect_datameer_instance_info(port)
    else
      puts "Sorry, port is in use."
    end
  end

  def stop_datameer_instance (datameer_version)
    `base_dir + datameer_version + "/./bin/conductor.sh stop")`
  end

  # Port / Process Information Gathering
  # =======================================================================

  def port_available? (port)
    `lsof -i :#{port}`.empty?
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

  # def get_pid (process_name)
  #   pid = `pgrep #{process_name}`.strip
  # end

end

# Driver Code
# =========================================================================

