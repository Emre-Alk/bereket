require "test_helper"

class Assos::DonationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get assos_donations_index_url
    assert_response :success
  end
end
