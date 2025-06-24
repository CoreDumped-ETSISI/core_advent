require "application_system_test_case"

class ProblemsTest < ApplicationSystemTestCase
  setup do
    @problem = problems(:one)
  end

  test "visiting the index" do
    visit problems_url
    assert_selector "h1", text: "Problems"
  end

  test "should create problem" do
    visit problems_url
    click_on "New problem"

    fill_in "Body", with: @problem.body
    fill_in "Correct answer", with: @problem.correct_answer
    fill_in "Lock time", with: @problem.lock_time
    fill_in "Title", with: @problem.title
    fill_in "Unlock time", with: @problem.unlock_time
    click_on "Create Problem"

    assert_text "Problem was successfully created"
    click_on "Back"
  end

  test "should update Problem" do
    visit problem_url(@problem)
    click_on "Edit this problem", match: :first

    fill_in "Body", with: @problem.body
    fill_in "Correct answer", with: @problem.correct_answer
    fill_in "Lock time", with: @problem.lock_time.to_s
    fill_in "Title", with: @problem.title
    fill_in "Unlock time", with: @problem.unlock_time.to_s
    click_on "Update Problem"

    assert_text "Problem was successfully updated"
    click_on "Back"
  end

  test "should destroy Problem" do
    visit problem_url(@problem)
    click_on "Destroy this problem", match: :first

    assert_text "Problem was successfully destroyed"
  end
end
