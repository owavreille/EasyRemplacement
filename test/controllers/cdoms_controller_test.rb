require 'test_helper'

class CdomsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

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
    get :edit, params: { id: @cdom.id }
    assert_response :success
  end

  test "should update cdom" do
    patch :update, params: { id: @cdom.id, cdom: { departement: @cdom.departement, name: @cdom.name, email: @cdom.email } }
    assert_redirected_to cdoms_path
  end

  test "should destroy cdom" do
    @site = Site.find_by(id: 1) 
    @site.update(cdom_id: nil) if @site.present?
    
    assert_difference('Cdom.count', -1) do
      delete :destroy, params: { id: 1 }
    end
  
    assert_redirected_to cdoms_path
  end

test "should not destroy cdom with associated sites" do
  # Créer un site associé au cdom
  @site = Site.create(cdom: @cdom, name: "Site 1")
  
  assert_no_difference('Cdom.count') do
    delete :destroy, params: { id: @cdom.id }
  end

  assert_redirected_to cdoms_path
  assert_equal "Le cdom est associé à des sites et ne peut pas être supprimé.", flash[:alert]
end

  
end
