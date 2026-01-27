require "test_helper"

class MatchListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get match_listings_index_url
    assert_response :success
  end

  test "should get show" do
    get match_listings_show_url
    assert_response :success
  end

  test "should get new" do
    get match_listings_new_url
    assert_response :success
  end
end
