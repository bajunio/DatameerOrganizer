# Properties file for Datameer_Organizer

# Specify the root directory containing your datameer installations
module DatameerOrganizerProperties
  attr_accessor :base_dir, :default_port
  extend self

    @base_dir = "/Users/bjunio/Desktop/datameer/datameer_installations"
    @default_port = 8080

end