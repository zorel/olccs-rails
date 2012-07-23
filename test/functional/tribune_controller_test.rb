require 'test_helper'

class TribuneControllerTest < ActionController::TestCase
  test "should get remote" do
    get :remote
    assert_response :success
  end

  test "should get post" do
    get :post
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get stats" do
    get :stats
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get history" do
    get :history
    assert_response :success
  end

end
