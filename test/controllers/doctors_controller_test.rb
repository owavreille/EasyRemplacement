require 'test_helper'

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doctor = doctors(:one)
    @user = users(:one)
    @user.update(role: true)
    sign_in @user
  end

  test "should redirect to root path if user is not an admin" do
    @user.update(role: false)
    get doctors_url
    assert_redirected_to root_path
    assert_equal "Accès non autorisé.", flash[:alert]
  end

  test "should get index" do
    get doctors_url
    assert_response :success
  end

  test "should get new" do
    get new_doctor_url
    assert_response :success
  end

  test "should create doctor" do
    assert_difference('Doctor.count') do
      post doctors_url, params: { doctor: { title: @doctor.title, last_name: @doctor.last_name, first_name: @doctor.first_name, rpps: @doctor.rpps, speciality: @doctor.speciality, conventional_sector: @doctor.conventional_sector, optam: @doctor.optam, phone: @doctor.phone, email: @doctor.email, signature_blob: @doctor.signature_blob } }
    end

    assert_redirected_to doctor_url(Doctor.last)
  end

  test "should get edit" do
    get edit_doctor_url(@doctor)
    assert_response :success
  end

  test "should update doctor" do
    patch doctor_url(@doctor), params: { doctor: { title: @doctor.title, last_name: @doctor.last_name, first_name: @doctor.first_name, rpps: @doctor.rpps, speciality: @doctor.speciality, conventional_sector: @doctor.conventional_sector, optam: @doctor.optam, phone: @doctor.phone, email: @doctor.email, signature_blob: @doctor.signature_blob } }
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
      delete doctor_url(@doctor)
    end

    assert_redirected_to doctors_url
  end
end
