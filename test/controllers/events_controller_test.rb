require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    sign_in @user

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, params: { event: {
        site_id: @event.site.id,
        doctor_id: @event.doctor_id,
        start_time: @event.start_time,
        end_time: @event.end_time,
        number_of_patients: @event.number_of_patients,
        helper: @event.helper,
        user_id: @user.id,
        amount: @event.amount,
        reversion: @event.reversion,
        amount_paid: @event.amount_paid,
        contract_generated: @event.contract_generated,
        contract_validated: @event.contract_validated,
        editable: @event.editable,
        contract_blob: @event.contract_blob
      } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should get edit" do
    get :edit, params: { id: @event.id }
    assert_response :success
  end

  test "should update event" do
    patch :update, params: { id: @event.id, event: {
      start_time: @event.start_time,
      end_time: @event.end_time
    } }
    assert_redirected_to event_url
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, params: { id: @event.id }
    end

    assert_redirected_to events_url
  end

  test "should book event" do
    assert_difference('@event.reload.user_id') do
      match :booking_event, params: { id: @event.id }
    end

    assert_redirected_to event_url(@event)
    assert_equal "Plage de Remplacement Réservée avec Succès.", flash[:notice]
  end

  test "should redirect to inactive page if user is not active" do
    @user.update(active: false)
    assert_redirected_to inactive_path
  end
end