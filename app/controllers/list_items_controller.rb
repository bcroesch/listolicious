class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /list_items
  # GET /list_items.xml
  # def index
  #     @list_items = ListItem.all
  # 
  #     respond_to do |format|
  #       format.html # index.html.erb
  #       format.xml  { render :xml => @list_items }
  #     end
  #   end

  # GET /list_items/1
  # GET /list_items/1.xml
  # def show
  #     @list_item = ListItem.find(params[:id])
  # 
  #     respond_to do |format|
  #       format.html # show.html.erb
  #       format.xml  { render :xml => @list_item }
  #     end
  #   end

  # GET /list_items/new
  # GET /list_items/new.xml
  # def new
  #     @list_item = ListItem.new
  # 
  #     respond_to do |format|
  #       format.html # new.html.erb
  #       format.xml  { render :xml => @list_item }
  #     end
  #   end

  # GET /list_items/1/edit
  # def edit
  #     @list_item = ListItem.find(params[:id])
  #   end

  # POST /list_items
  # POST /list_items.xml
  def create
    @activity = Activity.find_or_create_by_name(:name => params[:name], :user_id => current_user.id)
    @list = current_user.lists.find(params[:list_id])
    
    @list_item = current_user.list_items.new
    @list_item.activity = @activity
    @list_item.list = @list
    
    @list_item_count = current_user.list_items.where(:list_id => @list.id).size
    
    respond_to do |format|
      if @activity && @list_item.save
        format.js 
      else
        format.js { render :text => 'Error adding activity' }
      end
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.xml
  def update
    @list_item = current_user.list_items.find(params[:id])
    @list_item_count = current_user.list_items.where(:list_id => @list_item.list_id).size

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        format.js
      else
        format.js { render :text => "Error" }
      end
    end
  end

  # DELETE /list_items/1
  # DELETE /list_items/1.xml
  def destroy
    @list_item = current_user.list_items.find(params[:id])
    @list_item.destroy

    respond_to do |format|
      format.js
    end
  end
end
