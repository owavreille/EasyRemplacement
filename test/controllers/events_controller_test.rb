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
    get :show, params: { id: @event.id }
    assert_response :success
  end  

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should confirm event booking" do
    assert_difference('Event.count', 0) do
      put :booking, params: { id: @event.id }
    end
    assert_redirected_to event_url(@event)
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
    post :booking, params: { id: @event.id }
    assert_redirected_to event_url(@event)
    assert_equal "Plage de Remplacement Réservée avec Succès.", flash[:notice]
  end
  

  test "should redirect to inactive path if user is not active" do
    if @user.active == false
      assert_redirected_to inactive_path
    end
  end
  
end