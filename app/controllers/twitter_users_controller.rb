class TwitterUsersController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  include NLP
  
  def index
    @title = 'Polscy Użytkownicy Twittera'
    case sort = params[:sort]
    when 'najbardziej_aktywni'
      @users = TwitterUser.all(:order => "statuses_count DESC")
    when 'najchetniej_followani'
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
    
    url = "http://api.twitter.com/1/statuses/user_timeline.json?user_id=#{@user.profile_id}"
    json = Net::HTTP.get_response(URI.parse(url)).body
    data = ActiveSupport::JSON.decode(json)
    
    @user.name = data.first['user']['name']
    @user.profile_image_url = data.first['user']['profile_image_url']
    @user.url = data.first['user']['url']
    @user.description = data.first['user']['description']
    @user.listed_count = data.first['user']['listed_count']
    @user.followers_count = data.first['user']['followers_count']
    @user.friends_count = data.first['user']['friends_count']
    @user.statuses_count = data.first['user']['statuses_count']
    @user.screen_name = data.first['user']['screen_name']
    @user.save
        
    data.each do |ele|  
      id = ele['id']
      twitt = @user.twitts.find_by_twitt_id(id)
      
      unless twitt
        content = ele['text']
        puts content
        text = preprocess(content)

        if content.length.to_f / text.length.to_f < 2.0
          if check_if_polish(text)        
            twitt = Twitt.new
            twitt.body = content
            twitt.originally_created = ele['created_at'].to_datetime
            twitt.twitt_id = ele['id']
            twitt.source = ele['source']
            twitt.twitter_user_id = @user.id
            twitt.save
          end
        end
      end
    end
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "Uaktualniono użytkownika #{@user.screen_name}"
        redirect_to(@user) 
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

end
