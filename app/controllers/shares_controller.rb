class SharesController < ApplicationController
  # GET /shares
  # GET /shares.xml
  # def index
  #     @shares = Share.all
  # 
  #     respond_to do |format|
  #       format.html # index.html.erb
  #       format.xml  { render :xml => @shares }
  #     end
  #   end

  # GET /shares/1
  # GET /shares/1.xml
  # def show
  #     @share = Share.find(params[:id])
  # 
  #     respond_to do |format|
  #       format.html # show.html.erb
  #       format.xml  { render :xml => @share }
  #     end
  #   end

  # GET /shares/new
  # GET /shares/new.xml
  # def new
  #     @share = Share.new
  # 
  #     respond_to do |format|
  #       format.html # new.html.erb
  #       format.xml  { render :xml => @share }
  #     end
  #   end

  # GET /shares/1/edit
  # def edit
  #     @share = Share.find(params[:id])
  #   end

  # POST /shares
  # POST /shares.xml
  def create
    @share = Share.new(params[:share])
    @share.user_id = current_user.id
    @share.service = "facebook"
    
    name = "Listolicious.com"
    url = url_for(@share.shareable)
    if @share.shareable_type == "List"
      name = @share.shareable.name
    elsif @share.shareable_type == "ListItem"
      name = @share.shareable.activity.name
      url = url_for(@share.shareable.list)
    end
    
    if @share.shareable.user_id != current_user.id
      render :text => "failure", :status => 500
      return
    end
    
    begin
      fb_user = FbGraph::User.me(current_user.fb_access_token)
      fb_user.feed!(
        :message => @share.content,
        :link => url,
        :name => name
      )
    rescue FbGraph::Exception => e
      if e.code == 400
        render :text => "facebook_error", :status => 500
        return
      end
    end
    
    respond_to do |format|
      if @share.save
        format.js { render :text => "success" }
        #format.html { redirect_to(@share, :notice => 'Share was successfully created.') }
        #format.xml  { render :xml => @share, :status => :created, :location => @share }
      else
        format.js { render :text => "failure", :status => 500 }
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @share.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shares/1
  # PUT /shares/1.xml
  # def update
  #     @share = Share.find(params[:id])
  # 
  #     respond_to do |format|
  #       if @share.update_attributes(params[:share])
  #         format.html { redirect_to(@share, :notice => 'Share was successfully updated.') }
  #         format.xml  { head :ok }
  #       else
  #         format.html { render :action => "edit" }
  #         format.xml  { render :xml => @share.errors, :status => :unprocessable_entity }
  #       end
  #     end
  #   end

  # DELETE /shares/1
  # DELETE /shares/1.xml
  # def destroy
  #     @share = Share.find(params[:id])
  #     @share.destroy
  # 
  #     respond_to do |format|
  #       format.html { redirect_to(shares_url) }
  #       format.xml  { head :ok }
  #     end
  #   end
end
