require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get postphp" do
    get :postphp
    assert_response :success
  end

  test "should get remotephp" do
    get :remotephp
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
