module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

  	def current_user
    	@current_user ||= User.find_by(id: session[:user_id])
  	end

	def logged_in?
	    !current_user.nil?
	end

	def log_out
    	session.delete(:user_id)
    	@current_user = nil
  	end

  	def redirect_to_target_or_default(default, *args)
  		redirect_to(session[:return_to] || default, *args)
  		session[:return_to] = nil
  	end

  	def store_target_location
  		session[:return_to] = request.url
  	end
end
