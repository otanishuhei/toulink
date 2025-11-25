require "test_helper"

class Public::ParticipationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_participations_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_participations_destroy_url
    assert_response :success
  end
end
