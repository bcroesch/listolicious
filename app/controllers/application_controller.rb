class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  
  protect_from_forgery
  
  
  def home
    @selected_list = (params[:selected_list_id] == nil)? current_user.lists.find_by_name("Bucket List") : current_user.lists.find(params[:selected_list_id])
    @list_items = @selected_list.list_items unless @selected_list.nil?
    @lists = current_user.lists
  end
end
