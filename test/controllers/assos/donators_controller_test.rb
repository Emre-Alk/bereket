require "test_helper"

class Assos::DonatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get assos_donators_index_url
    assert_response :success
  end
end
