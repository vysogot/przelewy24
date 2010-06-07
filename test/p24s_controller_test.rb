require File.dirname(__FILE__) + '/test_helper.rb'
require 'p24s_controller.rb'
require 'action_controller/test_process'

class P24sController; def rescue_action(e) raise e end; end

class P24sControllerTest < Test::Unit::TestCase
  def setup
    @controller = P24sController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    ActionController::Routing::Routes.draw do |map|
      map.resources :p24s
    end
  end

  def test_index
    get :index
    assert_response :success
  end
end
