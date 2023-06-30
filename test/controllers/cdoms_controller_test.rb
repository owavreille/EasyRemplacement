require 'test_helper'

class CdomsControllerTest < ActiveSupport::TestCase

  setup do
    @cdom = cdoms(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cdom" do
    assert_difference('Cdom.count') do
      post :create, params: { cdom: { departement: @cdom.departement, name: @cdom.name, email: @cdom.email } }
    end
    assert_redirected_to cdoms_path
    end

  test "should get edit" do
    get :edit, params: { id: @cdom }
    assert_response :success
  end

  test "should update cdom" do
    patch :update, params: { id: @cdom, cdom: { departement: @cdom.departement, name: @cdom.name, email: @cdom.email } }
    assert_redirected_to cdoms_path
  end

  test "should destroy cdom" do
    assert_difference('Cdom.count', -1) do
      delete :destroy, params: { id: @cdom }
    end

    assert_redirected_to cdoms_path
  end
end
