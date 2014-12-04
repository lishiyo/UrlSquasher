class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

	# username and password params only available in Users#create, Sessions#create
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

	def require_current_user!
		redirect_to new_session_url if current_user.nil?
	end
	
	def require_same_user!
		user = User.find(params[:id])
		unless user == current_user
			flash[:notice] = "You are not authorized to view this profile."
			redirect_to new_session_url
		end
	end
	
end
