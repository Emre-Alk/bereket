require "test_helper"

class AssosControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get assos_dashboard_url
    assert_response :success
  end
end
