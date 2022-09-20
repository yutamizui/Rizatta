require "test_helper"

class SalesItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sales_items_index_url
    assert_response :success
  end

  test "should get show" do
    get sales_items_show_url
    assert_response :success
  end

  test "should get new" do
    get sales_items_new_url
    assert_response :success
  end

  test "should get edit" do
    get sales_items_edit_url
    assert_response :success
  end
end
