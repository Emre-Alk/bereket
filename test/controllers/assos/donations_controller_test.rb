require "test_helper"

class Assos::DonationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get assos_donations_new_url
    assert_response :success
  end

  test "should get create" do
    get assos_donations_create_url
    assert_response :success
  end
end
