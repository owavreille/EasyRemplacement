require "application_system_test_case"

class MailingListsTest < ApplicationSystemTestCase
  setup do
    @mailing_list = mailing_lists(:one)
  end

  test "visiting the index" do
    visit mailing_lists_url
    assert_selector "h1", text: "Mailing lists"
  end

  test "should create mailing list" do
    visit mailing_lists_url
    click_on "New mailing list"

    fill_in "Name", with: @mailing_list.name
    click_on "Create Mailing list"

    assert_text "Mailing list was successfully created"
    click_on "Back"
  end

  test "should update Mailing list" do
    visit mailing_list_url(@mailing_list)
    click_on "Edit this mailing list", match: :first

    fill_in "Name", with: @mailing_list.name
    click_on "Update Mailing list"

    assert_text "Mailing list was successfully updated"
    click_on "Back"
  end

  test "should destroy Mailing list" do
    visit mailing_list_url(@mailing_list)
    click_on "Destroy this mailing list", match: :first

    assert_text "Mailing list was successfully destroyed"
  end
end
