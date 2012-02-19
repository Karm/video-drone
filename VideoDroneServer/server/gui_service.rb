#
# VideoDroneServer
#
class GUIService
  
  def initialize log, video_drone_server
    @log = log
    @video_drone_server = video_drone_server
  end

  #Returns string due to web GUI...
  def list_drones
    "#{@video_drone_server.drones.keys}"
  end
  
  def play drone_id, path_to_file
    # TODO: Is video_player inited?
    (get_player drone_id).play_file path_to_file
  end
  
  def stop drone_id
    # TODO: Is video_player inited?
    (get_player drone_id).stop_player
  end
  
  def toggle_pause drone_id
    # TODO: Is video_player inited?
    return (get_player drone_id).toggle_pause
  end
  
  def quit drone_id
    # TODO: Is video_player inited?
    return (get_player drone_id).quit_player
  end
  
  def init drone_id
    # TODO: Is video_player quit?
    return (get_player drone_id).init_player
  end
  
  private
  def get_player drone_id
    return (@video_drone_server.drones.fetch drone_id).video_player
  end
  
end
