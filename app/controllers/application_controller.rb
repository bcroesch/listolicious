class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  
  protect_from_forgery
  
  def home 
    @list = current_user.lists.order("created_at desc").first
    redirect_to(list_url(@list))
  end
end
