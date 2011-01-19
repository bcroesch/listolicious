class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :destroy]
  
  def create
    omniauth = request.env["omniauth.auth"]
    puts omniauth.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      logger.debug "here 1"
      if omniauth["credentials"]["token"]
        authentication.user.fb_access_token = omniauth["credentials"]["token"]
        authentication.user.save
      end
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      logger.debug "here 2"
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :fb_access_token => omniauth["credentials"]["token"])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      logger.debug "here 3"
      user = User.find_by_email(omniauth['extra']['user_hash']['email']) || User.new
      user.apply_omniauth(omniauth)
      if user.save
        logger.debug "here 4"
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        logger.debug "here 5i"
        puts user.to_yaml
        puts user.errors.to_yaml
        session[:omniauth] = omniauth
        redirect_to new_registration_from_fb_url
      end
    end
  end
  
  def failure
    redirect_to(new_user_session_url :flash => {:error => 'Error authenticating with Facebook'})
  end
  
  # def destroy
  #   @authentication = current_user.authentications.find(params[:id])
  #   @authentication.destroy
  #   flash[:notice] = "Successfully destroyed authentication."
  #   redirect_to authentications_url
  # end
end
