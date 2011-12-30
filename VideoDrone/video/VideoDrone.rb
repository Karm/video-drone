require "./video/VideoPlayer"

#
# VideoDrone
#
class VideoDrone
  attr_reader :commands, :options, :ID, :video_player
  
  def initialize options, commands, log
    @commands = commands
    @options = options
    @log = log
    # Unique ID
    @ID = options[:ID]
    # Initialize video player implementation
    @video_player = VideoPlayer.new log, commands
    #Init the actual native player
    @video_player.init_player
  end
  
  def get_available_media
    return "Not yet supported"
  end
  
  def to_s
    return "Video Drone, ID:#{@ID}, Current video:#{@video_player.current_video}"
  end
end