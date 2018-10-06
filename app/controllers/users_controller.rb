class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
     @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Successful signup, so automatically log in this user.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #redirect_to user_url(@user) same as above
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      # Use strong parameters to prevent mass assignment vulnerability.
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
