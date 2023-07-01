require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    @user = User.new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, params: { user: { email: "test@example.com", password: "password" } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should get edit" do
    get :edit, params: { id: @user.id }
    assert_response :success
  end

  test "should update user" do
    patch :update, params: { user: { email: "updated@example.com" } }
    assert_redirected_to users_path

  end

  test "should activate user" do
    @user.update(active: true)
    assert_response :success
  end

  test "should delete signature profile" do
    @user.update(signature_blob_id: nil)
    assert_response :success
  end

  test "should delete signature" do
    @user.update(signature_blob_id: nil)
    assert_response :success
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.id }
    end

    assert_redirected_to users_url
  end
end
