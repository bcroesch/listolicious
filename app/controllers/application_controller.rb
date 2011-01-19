class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  
  protect_from_forgery
  
  def home 
    @list = current_user.lists.order("created_at desc").first
    if @list
      redirect_to(list_url(@list))
    else
      redirect_to(user_lists_url(current_user))
    end
  end
end
