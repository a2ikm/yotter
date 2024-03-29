class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.update_or_create_by_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    User.delete(session[:user_id])
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
