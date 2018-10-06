require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    # The patch method issues a PATCH request, which follows the same pattern
    # as get, post, and delete.
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    # Confirm the flash is not empty
    assert_not flash.empty?
    # Confirm successful redirect to the profile page
    assert_redirected_to @user
    # Reload the user’s values from the database
    @user.reload
    # Confirm name and email have been updated
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
