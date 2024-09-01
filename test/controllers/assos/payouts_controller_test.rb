require "test_helper"

class Assos::PayoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get assos_payouts_create_url
    assert_response :success
  end
end
