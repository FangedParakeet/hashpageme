class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  def require_login
    if session[:user_id].blank?
      redirect_to root_url, notice: "You must be logged in to be here!"
    end
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]    
  end
end
