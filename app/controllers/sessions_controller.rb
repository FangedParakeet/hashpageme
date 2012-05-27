class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to new_hpage_url
  end
  
  def destroy
    session[:user_id] = nil
    flash[:signed_out] = "Signed out!"
    redirect_to root_url
  end

	def failure
		flash[:alert] = 'Something went wrong!'
		redirect_to root_url
	end
end
