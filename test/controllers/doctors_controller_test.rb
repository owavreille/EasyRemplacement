require 'test_helper'

class DoctorsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @doctor = doctors(:one)
    @user = users(:one)
    @user.update(role: true)
    sign_in @user
  end

  test "should redirect to root path if user is not an admin" do
    @user.update(role: false)
    get :index
    assert_redirected_to root_path
    assert_equal "Accès non autorisé.", flash[:alert]
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create doctor" do
    Doctor.destroy_all # Supprime tous les médecins existants
    
    assert_difference('Doctor.count') do
      post :create, params: { doctor: { id: 1, title: @doctor.title, last_name: @doctor.last_name, first_name: @doctor.first_name, rpps: @doctor.rpps, speciality: @doctor.speciality, conventional_sector: @doctor.conventional_sector, optam: @doctor.optam, phone: @doctor.phone, email: @doctor.email, signature_blob: @doctor.signature_blob } }
    end
  
    assert_redirected_to doctors_path
  end
  

  test "should get edit" do
    get :edit, params: { id: @doctor.id }
    assert_response :success
  end

  test "should update doctor" do
    patch :update, params: { id: 1, doctor: { title: @doctor.title, last_name: @doctor.last_name, first_name: @doctor.first_name, rpps: @doctor.rpps, speciality: @doctor.speciality, conventional_sector: @doctor.conventional_sector, optam: @doctor.optam, phone: @doctor.phone, email: @doctor.email, signature_blob: @doctor.signature_blob } }
    assert_redirected_to doctor_url(@doctor)
    @doctor.reload
    assert_equal @doctor.title, @doctor.title
    assert_equal @doctor.last_name, @doctor.last_name
    assert_equal @doctor.first_name, @doctor.first_name
    assert_equal @doctor.rpps, @doctor.rpps
    assert_equal @doctor.speciality, @doctor.speciality
    assert_equal @doctor.conventional_sector, @doctor.conventional_sector
    assert_equal @doctor.optam, @doctor.optam
    assert_equal @doctor.phone, @doctor.phone
    assert_equal @doctor.email, @doctor.email
    assert_equal @doctor.signature_blob, @doctor.signature_blob
  end
  

  test "should destroy doctor" do
    assert_difference('Doctor.count', -1) do
      delete :destroy, params: { id: 1 }
    end
    assert_redirected_to doctors_url
  end
end
