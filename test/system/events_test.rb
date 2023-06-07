require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Amount", with: @event.amount
    fill_in "Doctor", with: @event.doctor_id
    fill_in "End time", with: @event.end_time
    check "Helper" if @event.helper
    fill_in "Number of patients", with: @event.number_of_patients
    fill_in "Reversion", with: @event.reversion
    fill_in "Site", with: @event.site_id
    fill_in "Start time", with: @event.start_time
    fill_in "User", with: @event.user_id
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Amount", with: @event.amount
    fill_in "Doctor", with: @event.doctor_id
    fill_in "End time", with: @event.end_time
    check "Helper" if @event.helper
    fill_in "Number of patients", with: @event.number_of_patients
    fill_in "Reversion", with: @event.reversion
    fill_in "Site", with: @event.site_id
    fill_in "Start time", with: @event.start_time
    fill_in "User", with: @event.user_id
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
