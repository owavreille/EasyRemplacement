require 'test_helper'

class OfficeControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @site = sites(:one)
    @user = users(:one)
    sign_in @user

  end

  test "should get index" do
    get :index
    assert_response :success
  end

end