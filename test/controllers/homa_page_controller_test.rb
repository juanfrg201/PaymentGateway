require "test_helper"

class HomaPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get homa_page_index_url
    assert_response :success
  end
end
