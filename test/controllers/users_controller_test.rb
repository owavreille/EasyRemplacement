require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @user = users(:one)
    @user.signature.attach(io: File.open('test/fixtures/files/logo.jpg'), filename: 'logo.jpg', content_type: 'image')
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

  test "should delete signature from profile" do
    assert @user.signature.attached? # Assurez-vous que la signature est attachée avant la suppression
  
    delete :delete_signature_profile, params: { id: @user.id }
    assert_redirected_to edit_user_registration_path(@user)
    assert_equal 'L\'image de la signature a été supprimée avec succès.', flash[:notice]
  
    @user.reload
    assert_not @user.signature.attached? # Vérifiez que la signature a bien été supprimée
  end
  
  test "should delete signature" do
    assert @user.signature.attached? # Assurez-vous que la signature est attachée avant la suppression
  
    delete :delete_signature, params: { id: @user.id }
    assert_redirected_to edit_user_path
    assert_equal 'L\'image de la signature a été supprimée avec succès.', flash[:notice]
  
    @user.reload
    assert_not @user.signature.attached? # Vérifiez que la signature a bien été supprimée
  end
  
  
  

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.id }
    end

    assert_redirected_to users_url
  end
end
