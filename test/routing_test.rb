require "#{File.dirname(__FILE__)}/test_helper"

class RoutingTest < Test::Unit::TestCase

  def setup
    ActionController::Routing::Routes.draw do |map|
      map.p24s
    end
  end

  def test_p24s_route
    assert_recognition :get, "/p24s", :controller => "p24s_controller", :action => "index"
  end

  private

  def assert_recognition(method, path, options)
    result = ActionController::Routing::Routes.recognize_path(path, :method => method)
    assert_equal options, result
  end
end
