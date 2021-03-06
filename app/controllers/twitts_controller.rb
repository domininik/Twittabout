class TwittsController < ApplicationController
  before_filter :require_user, :except => [:index]
  include NLP

  def index
    @title = "Tweety napisane po polsku"
    get_twitts

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
    response = Net::HTTP.get_response(URI.parse(url))
    json = response.body
    data = ActiveSupport::JSON.decode(json)
    if response.message != "OK"
      flash[:error] = "Wystąpił błąd: #{data["error"]}"
    else
      data.each do |ele|
        content = ele['text']
        logger.info content
        text = preprocess(content)

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
      flash[:notice] = "Pobrano nowe tweety"
    end
    redirect_to twitts_path 
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
