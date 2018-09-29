class SessionsController < ApplicationController
  def new
  end

  def create
    # All email addresses are stored in lower case
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in user
      # The next statement is shorthand for 'redirect_to user_url(user)'
      redirect_to user
    else
      # Rendering a template doesn't count as a request, so need to use flash.now
      # If just flash were used, the error message would persist into the next
      # request, which may be totally unrelated to a login.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
