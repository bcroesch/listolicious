class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  
  def new_from_fb
    @user = User.new
    #puts session.to_yaml
    @user.apply_omniauth(session[:omniauth])
    #puts @user.to_yaml
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end
