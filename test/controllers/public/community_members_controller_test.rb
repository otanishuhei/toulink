require "test_helper"

class Public::CommunityMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_community_members_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_community_members_destroy_url
    assert_response :success
  end
end
