require 'open3'

# VideoPlayer manipulates the native video player
# The current implementation supports mplayer
#
# TODO: Use abstract string constants instead of actual mplayer commands. 
class VideoPlayer
  attr_reader :log, :commands, :stdin, :stdout, :stderr, :current_video, :is_paused

  def initialize log, commands
    @log = log
    @commands = commands
    @is_paused = false
    @is_inited = false
  end

  # Opens mplayer in a slave mode and keeps it in IDLE state.  
  def init_player
    if @is_inited
      raise "Player already initialized."
    end
    @stdin, @stdout, @stderr = Open3.popen3 'mplayer -slave -quiet -idle'
    @is_inited = true
    @log.debug "mplayer has been initialised:" + @stdout.gets
  end

  # Play file & Go fullscreen immediately
  def play_file path
    unless @is_inited
      raise "Uninitialized player."
    end
    @stdin.puts "loadfile " + path
    @log.debug "mplayer has loaded file #{path} with message:" + @stdout.gets
    @stdin.puts "vo_fullscreen"
    @log.debug "mplayer has gone fullscreen:" + @stdout.gets
    @current_video = path
  end
  
  # Pause / Unpause video
  def toggle_pause
    unless @is_inited
      raise "Uninitialized player."
    end
    @is_paused ? @is_paused = false : @is_paused = true
    @stdin.puts "pause"
    @log.debug "mplayer has been paused/resumed:" + @stdout.gets
    
    if @is_paused
      @log.info "mplayer has been paused:" + @stdout.gets
    else
      @log.info "mplayer has been resumed:" + @stdout.gets
    end
    
    return @is_paused
  end
  
  # Stop video
  def stop_player
    unless @is_inited
      raise "Uninitialized player."
    end
    @stdin.puts "stop"
    @log.debug "mplayer has been stopped:" + stdout.gets
  end
  
  # Retrieve a real time mplayer console output
  def get_stats
    unless @is_inited
      raise "Uninitialized player."
    end
    return @stdout.gets
  end
  
  # Quit player and close streams
  def quit_player
    unless @is_inited
      raise "Uninitialized player."
    end
    @is_inited = false
    @stdin.puts "quit"
    #Woot? streams are gonna be closed for us by magic?
    #@stdin.close
    #@stdout.close
    #@stderr.close
    @log.debug "mplayer has quitted:" + stdout.gets
  end
  
end
