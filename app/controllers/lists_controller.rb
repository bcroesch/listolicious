class ListsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  
  # GET /lists
  # GET /lists.xml
  def index
    if params[:user_id] 
      @user = User.find(params[:user_id])
      if current_user && current_user.id == @user.id
          @lists = current_user.lists.all
      else
        @lists = @user.lists.where(:private => 0)
      end
      redirect_to(lists_url, :flash => {:error => 'That user does not exist'}) if @user.nil?
    elsif current_user
      @user = current_user
      @lists = current_user.lists.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /lists/1
  # GET /lists/1.xml
  def show
    @list = List.find(params[:id])
    
    if @list.private && (!current_user || current_user.id != @list.user_id)
      redirect_to(user_lists_url(@list.user), :flash => {:error => 'That list is private'})
      return
    end

    @list_items = @list.list_items.order("created_at desc") if @list
    @lists = current_user.lists.all if current_user

    respond_to do |format|
      format.html # show.html.erb
      #format.js
    end
  end

  # GET /lists/new
  # GET /lists/new.xml
  # def new
  #     @list = List.new
  # 
  #     respond_to do |format|
  #       format.html # new.html.erb
  #       #format.xml  { render :xml => @list }
  #       format.js
  #     end
  #   end

  # GET /lists/1/edit
  # def edit
  #     @list = current_user.lists.find(params[:id])
  #   end

  # POST /lists
  # POST /lists.xml
  def create
    @list = List.new(params[:list])
    @list.user_id = current_user.id
    
    respond_to do |format|
      if @list.save
        #format.html { redirect_to(@list, :notice => 'List was successfully created.') }
        #format.xml  { render :xml => @list, :status => :created, :location => @list }
        format.js
      else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
        format.js   { render :text => "Error creating list" }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.xml
  def update
    @list = current_user.lists.find(params[:id])
    
    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to(@list, :notice => 'List was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.xml
  def destroy
    @list = current_user.lists.find(params[:id])
    @list.destroy
    
    if params[:current_list] == params[:id]
      @next_list = current_user.lists.where("id != ?", params[:id]).first()
    else
      @next_list = params[:current_list]
    end

    respond_to do |format|
      format.html { 
        if @next_list
          redirect_to(list_url(@next_list)) 
        else
          redirect_to(lists_url)
        end
      }
      #format.js
      #format.xml  { head :ok }
    end
  end
end
