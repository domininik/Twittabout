class TwitterUsersController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :search]
  
  def index
    get_top_users
    @title = 'Polscy Użytkownicy Twittera'
    case sort = params[:sort]
    when 'najbardziej_aktywni'
      @users = TwitterUser.all(:order => "statuses_count DESC")
    when 'najpopularniejsi'
      @users = TwitterUser.all(:order => "followers_count DESC")
    else
      @users = TwitterUser.all(:order => "screen_name ASC")
    end
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    get_top_users
    @title = 'Polscy Użytkownicy Twittera'
    @user = TwitterUser.find(params[:id])
    @twitts = @user.twitts.paginate :page => params[:page], :per_page => 10, :order => "originally_created DESC"
        
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    @user = TwitterUser.find(params[:id])
    @user.update_data    

    respond_to do |format|
      format.html { 
        flash[:notice] = "Uaktualniono użytkownika #{@user.screen_name}"
        redirect_to(@user) 
      }
      format.xml  { head :ok }
    end
  end
  
  def update_all
    TwitterUser.all.each { |user| user.update_data }
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "Uaktualniono wszystkich użytkowników"
        redirect_to(twitter_users_path) 
      }
      format.xml  { head :ok }
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
  
  def search    
    @user = TwitterUser.find_by_screen_name(params[:q])
    
    if @user
      redirect_to twitter_user_url(@user)
    else
      flash[:error] = "Nie znaleziono takiego użytkownika"
      redirect_to twitter_users_path(:q => params[:q])
    end
  end
  
  private
  
  def get_top_users
    @top_users ||= TwitterUser.all(:order => "followers_count DESC", :limit => 20)
  end

end
