require "test_helper"

class DonatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get donators_dashboard_url
    assert_response :success
  end
end
