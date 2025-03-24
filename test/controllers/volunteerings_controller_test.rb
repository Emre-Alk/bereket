require "test_helper"

class VolunteeringsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get volunteerings_new_url
    assert_response :success
  end

  test "should get edit" do
    get volunteerings_edit_url
    assert_response :success
  end
end
