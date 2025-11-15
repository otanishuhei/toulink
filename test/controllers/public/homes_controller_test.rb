require "test_helper"

class Public::HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get public_homes_top_url
    assert_response :success
  end

  test "should get about" do
    get public_homes_about_url
    assert_response :success
  end

  test "should get privacy_policy" do
    get public_homes_privacy_policy_url
    assert_response :success
  end

  test "should get terms_of_service" do
    get public_homes_terms_of_service_url
    assert_response :success
  end
end
