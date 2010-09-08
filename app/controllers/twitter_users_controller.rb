class TwitterUsersController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  def index
    @users = TwitterUser.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = TwitterUser.find(params[:id])
    @twitts = @user.twitts.paginate :page => params[:page], :per_page => 10, :order => "originally_created DESC"
        
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end

  def delete
    @user = TwitterUser.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(twitter_users_url) }
      format.xml  { head :ok }
    end
  end

end
