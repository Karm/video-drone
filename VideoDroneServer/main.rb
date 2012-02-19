require 'drb'
require './server/video_drone_server'
require './server/gui_service'
require './server/web_sockets_service'

#
# VideoDroneServer entry point
#

#Logging
log = Logger.new(STDOUT)
log.level = Logger::DEBUG

options = eval(File.open('./conf/options') {|f| f.read })

#Initialize VideoDrone server so as Video Drones can register to it...
video_drone_server = VideoDroneServer.new log
gui_service = GUIService.new log, video_drone_server
websockets_service = WebSocketsService.new log, options, gui_service
  
DRb.start_service options[:DRb_start_service], video_drone_server
log.info "Server running at #{DRb.uri}"

websockets_service.init_websockets_worker
log.info "Browsers should be able to access our service now."

go = true

# TODO: EXIT does not work properly :-(
#       ^CTerminating WebSocket Server two times?
Signal.trap("INT") {
  go = false
  websockets_service.websockets_worker.join 1
  DRb.stop_service
  unless DRb.thread == nil
    DRb.thread.join
  end
}

how_many_drones = 0

while go
  unless how_many_drones == video_drone_server.drones.length
      how_many_drones = video_drone_server.drones.length
      websockets_service.update_drones
  end
  log.info "Video Drones available:" + gui_service.list_drones
  sleep 1
end
