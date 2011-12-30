require 'em-websocket'

#
# WebSocketsService
#
class WebSocketsService
  attr_reader :websockets_worker
    
  def initialize log, options, gui_service
    @options = options
    @gui_service = gui_service
    @log = log
    
    # Takes up to 4 white-space separated arguments
    # The first is command, the second is Video Drone ID (or 00 for broadcast)
    # The other two arguments are optional.
    # An example: play 2 /home/hipster/hype/movies/clip01.mov
    @regular_for_command = /\A(\S+) (\S+)[ ]?(\S*)[ ]?(\S*)$/
    @sockets = []
  end

  def init_websockets_worker
    @websockets_worker = Thread.new {
      EventMachine.run {
        EventMachine::WebSocket.start :host => @options[:WebSockets_host], :port => @options[:WebSockets_port], :debug => true do |ws|
          ws.onopen {
            @sockets << ws
            update_drones ws
          }
          ws.onmessage { |message|
            process_message message, ws 
          }
          ws.onclose {
            @sockets.delete ws
            @log.info "WebSocket closed"
          }
          ws.onerror {
            |e| @log.error "Error: #{e.message}"
          }
        end
      }
    }
  end

  def process_message message, ws   
    match = @regular_for_command.match message
    case match[1]
      when "play" then
        @gui_service.play match[2], match[3]
        send_to_all "playing #{match[2]} #{match[3]}"
        info = "Video Drone #{match[2]} should play #{match[3]} presently."
        @log.info info
        ws.send "log_info " + info
      when "stop" then
        @gui_service.stop match[2]
        send_to_all "stopped #{match[2]}"
        info = "Video Drone #{match[2]} should stop its current video."
        @log.info info
        ws.send "log_info " + info
      when "toggle_pause" then
        if @gui_service.toggle_pause match[2]
          send_to_all "paused #{match[2]}"
          info = "Video Drone #{match[2]} should pause its current video."
          @log.info info
          ws.send "log_info " + info
        else
          send_to_all "resumed #{match[2]}"
          info = "Video Drone #{match[2]} should resume its current video."
          @log.info info
          ws.send "log_info " + info
        end
      when "quit" then
        @gui_service.quit match[2]
        send_to_all "quitted #{match[2]}"
        info = "Video Drone #{match[2]} should quit its player."
        @log.info info
        ws.send "log_info " + info
      when "init" then
        @gui_service.init match[2]
        send_to_all "inited #{match[2]}"
        info = "Video Drone #{match[2]} should init its player."
        @log.info info
        ws.send "log_info " + info
      else
        @log.error "Unknown command:" + match[1] 
        ws.send "log_info Woot?!:" + match[1]
    end  
  end
  
  def send_to_all message
    @sockets.each {|s| s.send message}
  end
  
  def update_drones ws = nil
    if ws != nil
      ws.send "drones " + @gui_service.list_drones
    else
      send_to_all "drones " + @gui_service.list_drones 
    end
  end
  
end