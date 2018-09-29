require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    # The following two statements are not required in order to post to the
    # users path, but it is included to verify that the signup form renders
    # without error
    get signup_path
    assert_select "form[action='/signup']"

    # The following will test User.count both before and after posting the data
    # and verify they are the same.
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end

    # Verify a failed submission re-renders the #new action.
    assert_template 'users/new'

    # Verify the generated HTML includes the following elements
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do # the 2nd argument is the expected size of the difference
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # Follow the redirect after submission, which will result
    # in a rendering of the 'users/show' template
    follow_redirect!
    # Verify the #show action is rendered
    assert_template 'users/show'
    # Verify some sort of flash display happened. A more detailed test is likely
    # to be easily broken (brittle).
    assert_not flash.nil?
  end
end
