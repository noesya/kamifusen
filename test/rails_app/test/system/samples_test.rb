require "application_system_test_case"

class SamplesTest < ApplicationSystemTestCase
  setup do
    @sample = samples(:one)
  end

  test "visiting the index" do
    visit samples_url
    assert_selector "h1", text: "Samples"
  end

  test "creating a Sample" do
    visit samples_url
    click_on "New Sample"

    click_on "Create Sample"

    assert_text "Sample was successfully created"
    click_on "Back"
  end

  test "updating a Sample" do
    visit samples_url
    click_on "Edit", match: :first

    click_on "Update Sample"

    assert_text "Sample was successfully updated"
    click_on "Back"
  end

  test "destroying a Sample" do
    visit samples_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sample was successfully destroyed"
  end
end
