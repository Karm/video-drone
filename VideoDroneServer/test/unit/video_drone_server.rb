require './server/video_drone_server'
require 'minitest/mock'

class TestVideoDroneServer < MiniTest::Unit::TestCase

  def setup

    #Logging
    log = Logger.new(STDOUT)
    log.level = Logger::DEBUG
    @video_drone_server = VideoDroneServer.new log

    #VideoDrone #1
    @mock_video_drone_one = MiniTest::Mock.new
    # mock expects:
    #                           method  return  arguments
    @mock_video_drone_one.expect(:ID,    "666")

  end

  def test_register_drone
    @video_drone_server.register_drone @mock_video_drone_one
    retrieved_drone = @video_drone_server.drones["666"]
    assert_equal @mock_video_drone_one, retrieved_drone, "ID 666 should exist."
    assert_nil @video_drone_server.drones["999"], "It should be nil :-/"
  end

end
