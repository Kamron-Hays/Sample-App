require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do # the 2nd argument is the expected size of the difference
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end

    # Verify exactly one message was delivered. 
    assert_equal 1, ActionMailer::Base.deliveries.size
    # The assigns method lets us access instance variables in the corresponding
    # action. For example, the Users controller’s create action defines a @user
    # variable, so we can access it in the test using assigns(:user).
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # Follow the redirect after submission, which will result
    # in a rendering of the 'users/show' template
    follow_redirect!
    # Verify the #show action is rendered
    assert_template 'users/show'
    # Verify the new user is automatically signed in.
    assert is_logged_in?
    # Verify some sort of flash display happened. A more detailed test is likely
    # to be easily broken (brittle).
    assert_not flash.nil?
  end
end
