require 'test_helper'

class LearningObjectsControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
