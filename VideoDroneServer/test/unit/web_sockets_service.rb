require './server/video_drone_server'
require './server/gui_service'
require './server/web_sockets_service'
require 'minitest/mock'

class MockWS 
  def send message
    message
  end
end

class MockVideoPlayer
  def init_player
    "OK"
  end
  def play_file path
    path
  end
  def toggle_pause
    "OK"
  end
  def stop_player
    "OK"
  end
  def get_stats
    "OK"
  end
  def quit_player
    "OK"
  end
end

class TestWebSocketsService < MiniTest::Unit::TestCase

  def setup

    log = Logger.new(STDOUT)
    log.level = Logger::DEBUG
    video_drone_server = VideoDroneServer.new log

    #VideoDrone #1
    mock_video_drone_one = MiniTest::Mock.new
    # mock expects:
    #                           method  return  arguments
    mock_video_drone_one.expect(:ID,    "666")
    mock_video_drone_one.expect(:video_player,  MockVideoPlayer.new)
    video_drone_server.register_drone mock_video_drone_one

    #VideoDrone #2
    mock_video_drone_two = MiniTest::Mock.new
    # mock expects:
    #                           method          return  arguments
    mock_video_drone_two.expect(:ID,            "999")
    mock_video_drone_two.expect(:video_player,  MockVideoPlayer.new)
    video_drone_server.register_drone mock_video_drone_two

    gui_service = GUIService.new log, video_drone_server

    #Options
    mock_options = MiniTest::Mock.new

    @web_sockets_service = WebSocketsService.new log, mock_options, gui_service
    @mock_web_socket = MockWS.new

  end

  def test_play
    id = 666
    filename = "/home/hipster/hype/movies/clip01.mov"
    assert_equal "log_info Video Drone #{id} should play #{filename} presently.", @web_sockets_service.process_message("play #{id} #{filename}", @mock_web_socket)
    id = 999
    assert_equal "log_info Video Drone #{id} should play #{filename} presently.", @web_sockets_service.process_message("play #{id} #{filename}", @mock_web_socket)
  end

  def test_stop
    id = 666
    assert_equal "log_info Video Drone #{id} should stop its current video.", @web_sockets_service.process_message("stop #{id}", @mock_web_socket)
    id = 999
    assert_equal "log_info Video Drone #{id} should stop its current video.", @web_sockets_service.process_message("stop #{id}", @mock_web_socket)
  end

  def test_toggle_pause
    # Yes, normally there are two messages: one for paused and a different one for unpaused video.
    # Here we test just the web_sockets_service parsing commands.
    id = 666
    assert_equal "log_info Video Drone #{id} should pause its current video.", @web_sockets_service.process_message("toggle_pause #{id}", @mock_web_socket)
  end

  # TODO: Continue...

end
