require 'test_helper'

class CdomsControllerTest < ActionController::TestCase
  setup do
    @cdom = cdoms(:one)
    @user = users(:one)
  end

  test "should redirect to root path if user does not have required role" do
    get :index
    assert_redirected_to root_path
    assert_equal "Accès non autorisé.", flash[:alert]
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cdoms)
  end

  test "should show cdom" do
    get :show, params: { id: @cdom }
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cdom" do
    assert_difference('Cdom.count') do
      post :create, params: { cdom: { departement: @cdom.departement, name: @cdom.name, email: @cdom.email } }
    end

    assert_redirected_to cdom_path(assigns(:cdom))
  end

  test "should get edit" do
    get :edit, params: { id: @cdom }
    assert_response :success
  end

  test "should update cdom" do
    patch :update, params: { id: @cdom, cdom: { departement: @cdom.departement, name: @cdom.name, email: @cdom.email } }
    assert_redirected_to cdom_path(assigns(:cdom))
  end

  test "should destroy cdom" do
    assert_difference('Cdom.count', -1) do
      delete :destroy, params: { id: @cdom }
    end

    assert_redirected_to cdoms_path
  end
end
