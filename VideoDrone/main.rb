require 'drb'
require './video/video_drone'
require 'logger'

#
# VideoDrone entry point
#

# Read properties and options
# TODO: Server should push this command array...
commands = eval(File.open('./conf/commands') {|f| f.read })
options = eval(File.open('./conf/options') {|f| f.read })

# Logging
log = Logger.new(STDOUT)
log.level = Logger::DEBUG
  
# Start DRb and try to connect to the server  
DRb.start_service options[:DRb_start_service]
server = DRbObject.new nil, options[:DRbObject_new]

# Initialize Video Drone and register it with server  
video_drone = VideoDrone.new(options, commands, log).extend DRbUndumped  
server.register_drone video_drone

go = true

Signal.trap("INT") {
  log.debug "Terminating gracefully..."
  go = false
  server.remove_drone video_drone
  DRb.stop_service
}

while go
  #TODO: video_drone.get whatever
  puts "Waiting..."
  begin
  sleep 5
  rescue
    "Interrupted."
  end
end

unless DRb.thread == nil
  DRb.thread.join 5
end
