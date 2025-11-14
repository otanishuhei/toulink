require "test_helper"

class Public::CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_communities_index_url
    assert_response :success
  end

  test "should get show" do
    get public_communities_show_url
    assert_response :success
  end

  test "should get new" do
    get public_communities_new_url
    assert_response :success
  end

  test "should get create" do
    get public_communities_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_communities_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_communities_update_url
    assert_response :success
  end

  test "should get confirm_delete" do
    get public_communities_confirm_delete_url
    assert_response :success
  end

  test "should get withdraw" do
    get public_communities_withdraw_url
    assert_response :success
  end
end
