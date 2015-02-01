=begin


TODO:
Add netstat to troubleshoot connections
Add `ps aux` ability



=end




require_relative 'datameer_organizer.properties.rb'
# require 'socket'

class DatameerOrganizer
  include DatameerOrganizerProperties

  attr_accessor :datameer_versions
  attr_accessor :base_dir

  def initialize
    @base_dir = DatameerOrganizerProperties.base_dir
    @datameer_versions = []
  end

  def collect_datameer_versions
    Dir.glob(base_dir + '/*').select do |path_to_datameer|
      datameer_versions << "/" + path_to_datameer.split('/')[-1]
    end
  end

  def start_datameer_instance (datameer_version)
    exec(base_dir + datameer_version + "/./bin/conductor.sh start")
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



  # def open_port? (host, port)
  #   sock = Socket.new(:INET, :STREAM)
  #   raw = Socket.sockaddr_in(port, host)
  #   puts "#{port} open." if sock.connect(raw)

  # rescue (Errno::ECONNREFUSED)
  # rescue(Errno::ETIMEDOUT)
  # end

end