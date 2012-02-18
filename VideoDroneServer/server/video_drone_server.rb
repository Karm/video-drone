require 'logger'

#
# VideoDroneServer
#
class VideoDroneServer
  attr_reader :drones
  def initialize log
    @log = log
    @drones = Hash.new
  end

  def register_drone video_drone
    @drones[video_drone.ID] = video_drone
    @log.debug "Dorne #{video_drone} has been registered."
  end
  
  def remove_drone video_drone
    @drones.delete video_drone.ID
    @log.debug "Dorne #{video_drone} has left us."
  end

  # TODO: Create a method for an active pushing of player's status...
  
end