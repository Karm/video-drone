require './server/video_drone_server'
require './server/gui_service'
require 'minitest/mock'

class TestGUIService < MiniTest::Unit::TestCase

  def setup

    log = Logger.new(STDOUT)
    log.level = Logger::DEBUG
    video_drone_server = VideoDroneServer.new log
    mock_video_drone = MiniTest::Mock.new
    # mock expects:
    #           method                return  arguments
    mock_video_drone.expect(:get_available_media, "Not yet supported")
    mock_video_drone.expect(:ID,                  666)
    video_drone_server.register_drone mock_video_drone
    @gui_service = GUIService.new log, video_drone_server

  end

  def test_list_drones
    assert_equal "[666]", @gui_service.list_drones
  end

  # TODO: Do we need to go through delegation methods?
  #       Probably not, let's just test the player...

end
