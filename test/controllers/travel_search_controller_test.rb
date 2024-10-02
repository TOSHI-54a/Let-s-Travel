require "test_helper"

class TravelSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get travel_search_index_url
    assert_response :success
  end
end
