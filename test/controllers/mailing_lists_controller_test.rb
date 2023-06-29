require 'test_helper'

class MailingListsControllerTest < ActionController::TestCase
  setup do
    @mailing_list = mailing_lists(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should redirect to root path if user role is not authorized" do
    @user.update(role: false)
    get :index
    assert_redirected_to root_path
    assert_equal "Accès non autorisé.", flash[:alert]
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mailing_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:mailing_list)
  end

  test "should create mailing_list" do
    assert_difference('MailingList.count') do
      post :create, params: { mailing_list: { name: @mailing_list.name, text: @mailing_list.text, site_id: @mailing_list.site_id } }
    end
    assert_redirected_to mailing_lists_url
    assert_equal "La Mailing list a bien été créée !", flash[:notice]
  end

  test "should get edit" do
    get :edit, params: { id: @mailing_list.id }
    assert_response :success
    assert_not_nil assigns(:mailing_list)
  end

  test "should update mailing_list" do
    patch :update, params: { id: @mailing_list.id, mailing_list: { name: @mailing_list.name, text: @mailing_list.text, site_id: @mailing_list.site_id } }
    assert_redirected_to mailing_lists_url
    assert_equal "La Mailing list a bien été modifiée !", flash[:notice]
  end

  test "should destroy mailing_list" do
    assert_difference('MailingList.count', -1) do
      delete :destroy, params: { id: @mailing_list.id }
    end
    assert_redirected_to mailing_lists_url
    assert_equal "La Mailing list a bien été supprimée !", flash[:notice]
  end
end
