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
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    # The "signed" method encrypts the user_id, since cookies are not themselves encrypted
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any), nil otherwise.
  def current_user
    # Only perform the database search if user_id is NOT nil
    # (i.e. someone is logged in).
    if (user_id = session[:user_id])
      # Only perform the database search if @current_user is nil.
      # This prevents multiple hits on the database.
      @current_user ||= User.find_by(id: user_id)
    # If user is not signed in, automatically sign them in
    # if they're "remembered" from a previous sign-in.
    elsif (user_id = cookies.signed[:user_id])
      #raise # used to determine whether a specific branch is exercised in tests
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
