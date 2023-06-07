require "test_helper"

class CdomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cdom = cdoms(:one)
  end

  test "should get index" do
    get cdoms_url
    assert_response :success
  end

  test "should get new" do
    get new_cdom_url
    assert_response :success
  end

  test "should create cdom" do
    assert_difference("Cdom.count") do
      post cdoms_url, params: { cdom: { departement: @cdom.departement, id: @cdom.id, mail: @cdom.mail, nom: @cdom.nom } }
    end

    assert_redirected_to cdom_url(Cdom.last)
  end

  test "should show cdom" do
    get cdom_url(@cdom)
    assert_response :success
  end

  test "should get edit" do
    get edit_cdom_url(@cdom)
    assert_response :success
  end

  test "should update cdom" do
    patch cdom_url(@cdom), params: { cdom: { departement: @cdom.departement, id: @cdom.id, mail: @cdom.mail, nom: @cdom.nom } }
    assert_redirected_to cdom_url(@cdom)
  end

  test "should destroy cdom" do
    assert_difference("Cdom.count", -1) do
      delete cdom_url(@cdom)
    end

    assert_redirected_to cdoms_url
  end
end
