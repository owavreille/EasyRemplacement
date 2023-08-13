require 'test_helper'

class ContractsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    @doctor = doctors(:one)
    @site = sites(:one)
    sign_in @user
  end

test "should generate contract" do
  @event.user_id = @user.id
  @event.save
  
    contract_template = File.read(Rails.root.join('public', 'contrat.html'))

    contract = contract_template.gsub('user.title', @user.title.to_s)
                               .gsub('user.last_name', @user.last_name.to_s)
                               .gsub('user.first_name', @user.first_name.to_s)
                               .gsub('user.email', @user.email.to_s)
                               .gsub('user.phone', @user.phone.to_s)
                               .gsub('user.address', @user.address.to_s)
                               .gsub('user.postal_code', @user.postal_code.to_s)
                               .gsub('user.city', @user.city.to_s)
                               .gsub('user.siret_number', @user.siret_number.to_s)
                               .gsub('user.license_number', @user.license_number.to_s)
                               .gsub('doctor.title', @doctor.title.to_s)
                               .gsub('doctor.first_name', @doctor.first_name.to_s)
                               .gsub('doctor.last_name', @doctor.last_name.to_s)
                               .gsub('doctor.rpps', @doctor.rpps.to_s)
                               .gsub('doctor.email', @doctor.email.to_s)
                               .gsub('doctor.phone', @doctor.phone.to_s)
                               .gsub('site.name', @site.name.to_s)
                               .gsub('site.address', @site.address.to_s)
                               .gsub('site.postal_code', @site.postal_code.to_s)
                               .gsub('site.city', @site.city.to_s)
                               .gsub('event.start_date', @event.start_time.strftime("%d/%m/%Y").to_s)
                               .gsub('event.end_date', @event.end_time.strftime("%d/%m/%Y").to_s)
                               .gsub('event.start_time', @event.start_time.strftime("%H:%M").to_s)
                               .gsub('event.end_time', @event.end_time.strftime("%H:%M").to_s)
                               .gsub('event.reversion', @event.reversion.to_s)

    contract_with_doctor_image = contract.gsub('doctor.signature', 'Aucune signature disponible')
    contract_with_user_image = contract_with_doctor_image.gsub('user.signature', 'Aucune signature disponible')

    Tempfile.open(['generated_contrat', '.txt']) do |temp_file|
      temp_file.write(contract_with_user_image)
      temp_file.rewind

      post :generate_contract, params: { id: @event.id }
      assert_redirected_to datas_url
      @event.reload
      assert_equal true, @event.contract_generated
      assert_not_nil @event.contract_blob
      assert_equal "Le fichier de contrat a été créé avec succès.", flash[:notice]
    end
  end

  test "should view contract" do
    @event.update(contract_blob: fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'contract.txt')))
    get :view_contract, params: { id: @event.id }
    assert_response :success
  end

  test "should validate contract" do
    patch :validate_contract, params: { id: @event.id }
    assert_redirected_to userdata_url
    @event.reload
    assert_equal true, @event.contract_validated
    assert_equal "Contrat validé et envoyé au Conseil de l'Ordre!", flash[:notice]
  end
end