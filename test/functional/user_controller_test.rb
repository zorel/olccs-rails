require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get save_olcc_cookie" do
    get :save_olcc_cookie
    assert_response :success
  end

  test "should get destroy_olcc_cookie" do
    get :destroy_olcc_cookie
    assert_response :success
  end

end
