require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @site = sites(:one)
    @user = users(:one)
    @cdom = cdoms(:one)
    sign_in @user
  end


  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:site)
  end

  test "should create site" do
    cdom = Cdom.create(departement: "01")
    assert_difference('Site.count') do
      post :create, params: { site: { name: @site.name, address: @site.address, postal_code: @site.postal_code, city: @site.city, software: @site.software, informations: @site.informations, cdom_id: cdom.id, color: @site.color, min_patients: @site.min_patients, max_patients: @site.max_patients, min_patients_helped: @site.min_patients_helped, max_patients_helped: @site.max_patients_helped, am_min_hour: @site.am_min_hour, am_max_hour: @site.am_max_hour, pm_min_hour: @site.pm_min_hour, pm_max_hour: @site.pm_max_hour } }
    end
  
    assert_redirected_to site_url(assigns(:site))
    assert_equal "Le site a bien été créé !", flash[:notice]
    assert_not_nil assigns(:mailing_list)
    assert_equal "Mailing List #{assigns(:site).name}", assigns(:mailing_list).name
  end
  
  

  test "should get edit" do
    get :edit, params: { id: @site.id }
    assert_response :success
    assert_not_nil assigns(:site)
  end

  test "should update site" do
    patch :update, params: { id: @site.id, site: { name: @site.name, address: @site.address, postal_code: @site.postal_code, city: @site.city, software: @site.software, informations: @site.informations, cdom_id: Cdom.first.id, color: @site.color, min_patients: @site.min_patients, max_patients: @site.max_patients, min_patients_helped: @site.min_patients_helped, max_patients_helped: @site.max_patients_helped, am_min_hour: @site.am_min_hour, am_max_hour: @site.am_max_hour, pm_min_hour: @site.pm_min_hour, pm_max_hour: @site.pm_max_hour } }
    assert_redirected_to site_url(assigns(:site))
    assert_equal "Le site a bien été modifié !", flash[:notice]
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, params: { id: @site.id } if @site.present?
    end
    assert_redirected_to sites_url
    assert_equal "Le site a bien été supprimé !", flash[:notice]
  end
end
