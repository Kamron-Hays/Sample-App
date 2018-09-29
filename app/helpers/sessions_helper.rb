module SessionsHelper

  # Logs in the given user. This functionality is placed in a helper, because
  # it will be used in a couple different places.
  def log_in(user)
    # Place a temporary cookie on the user’s browser containing an encrypted
    # version of the user’s id.
    session[:user_id] = user.id
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the current logged-in user (if any), nil otherwise.
  def current_user
    # Only perform the database search if user_id is NOT nil
    # (i.e. someone is logged in).
    if session[:user_id]
      # Only perform the database search if @current_user is nil.
      # This prevents multiple hits on the database.
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end