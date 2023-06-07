require "test_helper"

class MailingListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mailing_list = mailing_lists(:one)
  end

  test "should get index" do
    get mailing_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_mailing_list_url
    assert_response :success
  end

  test "should create mailing_list" do
    assert_difference("MailingList.count") do
      post mailing_lists_url, params: { mailing_list: { name: @mailing_list.name } }
    end

    assert_redirected_to mailing_list_url(MailingList.last)
  end

  test "should show mailing_list" do
    get mailing_list_url(@mailing_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_mailing_list_url(@mailing_list)
    assert_response :success
  end

  test "should update mailing_list" do
    patch mailing_list_url(@mailing_list), params: { mailing_list: { name: @mailing_list.name } }
    assert_redirected_to mailing_list_url(@mailing_list)
  end

  test "should destroy mailing_list" do
    assert_difference("MailingList.count", -1) do
      delete mailing_list_url(@mailing_list)
    end

    assert_redirected_to mailing_lists_url
  end
end
