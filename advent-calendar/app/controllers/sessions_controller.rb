
class SessionsController < ApplicationController
  def new
    # Redirect if already logged in
    redirect_to root_path if current_user
  end

  def create
    # Debug: Check what params are being received
    Rails.logger.debug "Login params: #{params.inspect}"

    user = User.find_by(email: params[:email]&.downcase&.strip)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      Rails.logger.debug "User #{user.id} logged in successfully"
      redirect_to root_path, notice: "Logged in successfully"
    else
      Rails.logger.debug "Login failed for email: #{params[:email]}"
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Logged out successfully"
  end
end
