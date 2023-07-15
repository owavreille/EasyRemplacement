require "test_helper"

class AppSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get app_settings_index_url
    assert_response :success
  end

  test "should get update" do
    get app_settings_update_url
    assert_response :success
  end
end
