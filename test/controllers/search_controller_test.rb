require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get jobs" do
    get :jobs
    assert_response :success
  end

  test "should get friends" do
    get :friends
    assert_response :success
  end

  test "should get posters" do
    get :posters
    assert_response :success
  end

end
