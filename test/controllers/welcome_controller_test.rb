require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :panel
    assert_response :success
  end

end
