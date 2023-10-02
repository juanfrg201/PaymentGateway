require "test_helper"

class PayuControllerTest < ActionDispatch::IntegrationTest
  test "should get confirmation" do
    get payu_confirmation_url
    assert_response :success
  end

  test "should get response" do
    get payu_response_url
    assert_response :success
  end
end
