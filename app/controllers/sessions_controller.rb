class SessionsController < ApplicationController
  skip_before_filter :store_target_location
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      flash[:notice] = "Logged in successfully."
  		log_in user
  		redirect_to_target_or_default(user)
  	else
    	flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
    flash[:notice] = "You have been logged out."
  	log_out
  	redirect_to_target_or_default(root_path)
  end
end
