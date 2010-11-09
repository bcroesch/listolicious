class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /list_items
  # GET /list_items.xml
  def index
    @list_items = ListItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @list_items }
    end
  end

  # GET /list_items/1
  # GET /list_items/1.xml
  def show
    @list_item = ListItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/new
  # GET /list_items/new.xml
  def new
    @list_item = ListItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/1/edit
  def edit
    @list_item = ListItem.find(params[:id])
  end

  # POST /list_items
  # POST /list_items.xml
  def create

    @activity = Activity.find_or_create_by_name(:name => params[:name], :user_id => current_user.id)
    @list_item = current_user.list_items.new(:activity => @activity, :list_id => params[:list_id])
    @list_item_count = current_user.list_items.where(:list_id => params[:list_id]).size
    
    respond_to do |format|
      if @activity && @list_item.save
        format.js
        #format.html { redirect_to(@planned_activity, :notice => 'PlannedActivity was successfully created.') }
        #format.xml  { render :xml => @planned_activity, :status => :created, :location => @planned_activity }
      else
        format.js { render :text => 'Error adding activity' }
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @planned_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.xml
  def update
    @list_item = current_user.list_items.find(params[:id])
    @list_item_count = current_user.list_items.where(:list_id => @list_item.list_id).size
    logger.debug @list_item_count
    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        format.js
        #format.html { redirect_to(@list_item, :notice => 'List item was successfully updated.') }
        #format.xml  { head :ok }
      else
        #format.html { render :action => "edit" }
        #format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /list_items/1
  # DELETE /list_items/1.xml
  def destroy
    @list_item = current_user.list_items.find(params[:id])
    @list_item.destroy

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end
