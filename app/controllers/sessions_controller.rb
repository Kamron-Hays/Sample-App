class SessionsController < ApplicationController
  def new
  end

  def create
    # All email addresses are stored in lower case
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_back_or is a helper function in app/helpers/sessions_helper.rb
      redirect_back_or user
    else
      # Rendering a template doesn't count as a request, so need to use flash.now
      # If just flash were used, the error message would persist into the next
      # request, which may be totally unrelated to a login.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
