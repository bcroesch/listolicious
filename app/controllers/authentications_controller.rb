class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :failure]
  
  def create
    omniauth = request.env["omniauth.auth"]
    puts omniauth.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      if omniauth["credentials"]["token"]
        authentication.user.fb_access_token = omniauth["credentials"]["token"]
        authentication.user.save
      end
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :fb_access_token => omniauth["credentials"]["token"])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.find_by_email(omniauth['extra']['user_hash']['email']) || User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        puts user.to_yaml
        puts user.errors.to_yaml
        session[:omniauth] = omniauth
        redirect_to new_registration_from_fb_url
      end
    end
  end
  
  def failure
    redirect_to(new_user_session_url, :flash => {:error => 'Error authenticating with Facebook'})
  end
  
  # def destroy
  #   @authentication = current_user.authentications.find(params[:id])
  #   @authentication.destroy
  #   flash[:notice] = "Successfully destroyed authentication."
  #   redirect_to authentications_url
  # end
end
