require "application_system_test_case"

class CdomsTest < ApplicationSystemTestCase
  setup do
    @cdom = cdoms(:one)
  end

  test "visiting the index" do
    visit cdoms_url
    assert_selector "h1", text: "Cdoms"
  end

  test "should create cdom" do
    visit cdoms_url
    click_on "New cdom"

    fill_in "Departement", with: @cdom.departement
    fill_in "Id", with: @cdom.id
    fill_in "Mail", with: @cdom.email
    fill_in "Nom", with: @cdom.name
    click_on "Create Cdom"

    assert_text "Cdom was successfully created"
    click_on "Back"
  end

  test "should update Cdom" do
    visit cdom_url(@cdom)
    click_on "Edit this cdom", match: :first

    fill_in "Departement", with: @cdom.departement
    fill_in "Id", with: @cdom.id
    fill_in "Mail", with: @cdom.email
    fill_in "Nom", with: @cdom.name
    click_on "Update Cdom"

    assert_text "Cdom was successfully updated"
    click_on "Back"
  end

  test "should destroy Cdom" do
    visit cdom_url(@cdom)
    click_on "Destroy this cdom", match: :first

    assert_text "Cdom was successfully destroyed"
  end
end
