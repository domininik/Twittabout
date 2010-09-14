class TwitterUsersController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :search]
  include NLP
  
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
  
  # TODO make auto_update
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
  
  def search_new
    TwitterUser.all.each do |user|
      friends_url = "http://api.twitter.com/1/statuses/friends.json?user_id=#{user.profile_id}"
      followers_url = "http://api.twitter.com/1/statuses/followers.json?user_id=#{user.profile_id}"
      
      response = Net::HTTP.get_response(URI.parse(friends_url))
      json = response.body
      data = ActiveSupport::JSON.decode(json)
      if response.message == "OK"
        data.each do |ele|
          text = preprocess(ele['status']['text']) if ele['status'] 
          if text and check_if_polish(text)
            id = ele['id']
            user = TwitterUser.find_by_profile_id(id)
            unless user
              user = TwitterUser.new
              user.profile_id = id
              user.name = ele['name']
              user.profile_image_url = ele['profile_image_url']
              user.url = ele['url']
              user.description = ele["description"]
              user.listed_count = ele['listed_count']
              user.followers_count = ele['followers_count']
              user.friends_count = ele['friends_count']
              user.statuses_count = ele['statuses_count']
              user.screen_name = ele['screen_name']
              user.save
            end
          end
        end
      end
    end
    flash[:notice] = "Wyszukano nowych użytkowników"    
    redirect_to(twitter_users_path) 
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
