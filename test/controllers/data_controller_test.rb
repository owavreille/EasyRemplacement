require 'test_helper'

class DataControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    @doctor = doctors(:one)
    @site = sites(:one)
    sign_in @user

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get userdata" do
    get :userdata
    assert_response :success
  end

  test "should update amount" do
    amount = 100
    reversion = @event.reversion
    amount_paid = reversion.present? ? amount * reversion / 100 : 0

    patch :update_amount, params: { id: @event.id, amount: amount }
    assert_redirected_to datas_url
    @event.reload
    assert_equal amount, @event.amount
    assert_equal amount_paid, @event.amount_paid
    assert_equal "Montant du remplacement et Montant à reverser mis à jour avec succès.", flash[:notice]
  end

end
