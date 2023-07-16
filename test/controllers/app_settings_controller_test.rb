require 'test_helper'

class AppSettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @app_settings = app_settings(:one)
    sign_in @user
  end

  test "should get index" do
    get app_settings_url
    assert_response :success
  end

  test "should update app settings" do
    patch app_setting_url(@app_settings), params: { app_setting: { app_name: "New App Name" } }
    assert_redirected_to app_settings_path
    assert_equal "Paramètres mis à jour avec succès !", flash[:notice]
  end
  
  
end
