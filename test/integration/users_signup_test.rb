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
end
