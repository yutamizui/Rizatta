require "test_helper"

class TimeframesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timeframes_index_url
    assert_response :success
  end

  test "should get new" do
    get timeframes_new_url
    assert_response :success
  end

  test "should get edit" do
    get timeframes_edit_url
    assert_response :success
  end
end
