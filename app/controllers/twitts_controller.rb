class TwittsController < ApplicationController
  before_filter :require_user, :except => [:index]
  include NLP

  def index
    @all_size = Twitt.all.size
    if cat = params[:temat]
      @twitts = Twitt.paginate :page => params[:page], :per_page => 10, :conditions => "category = '#{cat}'", :order => "originally_created DESC"
    else
      @twitts = Twitt.paginate :page => params[:page], :per_page => 10, :order => "originally_created DESC"
    end

    respond_to do |format|
      format.html {}
    end
  end 
  
  def destroy
    @twitt = Twitt.find(params[:id])
    @twitt.destroy

    respond_to do |format|
      format.html { redirect_to(twitts_url) }
      format.xml  { head :ok }
    end
  end

  def feed
    url = params[:url]
    json = Net::HTTP.get_response(URI.parse(url)).body
    data = ActiveSupport::JSON.decode(json)
    data.each do |ele|
      content = ele['text']
      puts content
      text = preprocess(content)

      if content.length.to_f / text.length.to_f < 2.0
        if check_if_polish(text)
          profile_id = ele['user']['id']
          user ||= TwitterUser.find_by_profile_id(profile_id)
          unless user
            user = TwitterUser.new
            user.name = ele['user']['name']
            user.screen_name = ele['user']['screen_name']
            user.profile_image_url = ele['user']['profile_image_url']
            user.url = ele['user']['url']
            user.profile_id = profile_id
            user.description = ele['user']['description']
            user.listed_count = ele['user']['listed_count']
            user.followers_count = ele['user']['followers_count']
            user.friends_count = ele['user']['friends_count']
            user.statuses_count = ele['user']['statuses_count']
            user.save
          end
          
          twitt = Twitt.new
          twitt.body = content
          twitt.originally_created = ele['created_at'].to_datetime
          twitt.twitt_id = ele['id']
          twitt.source = ele['source']
          twitt.twitter_user_id = user.id
          twitt.save
        end
      end
    end
   
    respond_to do |format|
      format.html { 
        flash[:notice] = "Pobrano nowe tweety"
        redirect_to twitts_path 
      }
    end
  end
  
  def update_categories
    Twitt.all.each { |twitt| twitt.check_category }

    respond_to do |format|
      format.html {
        flash[:notice] = "Uaktualniono kategorie"
        redirect_to twitts_path
      }
    end
  end

end
