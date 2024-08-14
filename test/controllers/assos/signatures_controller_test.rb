require "test_helper"

class Assos::SignaturesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get assos_signature_new_url
    assert_response :success
  end

  test "should get create" do
    get assos_signature_create_url
    assert_response :success
  end

  test "should get update" do
    get assos_signature_update_url
    assert_response :success
  end
end
