require "test_helper"

class MatchRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get match_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get match_requests_show_url
    assert_response :success
  end

  test "should get new" do
    get match_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get match_requests_create_url
    assert_response :success
  end
end
