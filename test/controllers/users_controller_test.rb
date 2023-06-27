require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get show" do
    get user_url(@user)
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: "test@example.com", password: "password" } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: "updated@example.com" } }
    assert_redirected_to users_url
    @user.reload
    assert_equal "updated@example.com", @user.email
  end

  test "should activate user" do
    patch active_user_url(@user)
    assert_redirected_to users_url
    @user.reload
    assert_equal true, @user.active
  end

  test "should delete signature profile" do
    delete delete_signature_profile_user_url(@user)
    assert_redirected_to edit_user_registration_url(@user)
    @user.reload
    assert_nil @user.signature_blob
  end

  test "should delete signature" do
    delete delete_signature_user_url(@user)
    assert_redirected_to edit_user_url(@user)
    @user.reload
    assert_nil @user.signature_blob
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
