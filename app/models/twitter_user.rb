class TwitterUser < ActiveRecord::Base
  has_many :twitts, :dependent => :destroy
  include NLP
  
  named_scope :verified, :conditions => { :polish => true }
  named_scope :unverified, :conditions => { :polish => nil }

  after_create :update_total_users
  after_destroy :update_total_users

  def to_param
    "#{id}-#{screen_name}"
  end
  
  def latest_tweet
    Twitt.all(:conditions => "twitter_user_id = #{self.id}", :order => "originally_created DESC").first
  end
  
  def update_data
    url = "http://api.twitter.com/1/statuses/user_timeline.json?user_id=#{self.profile_id}"
    response = Net::HTTP.get_response(URI.parse(url))
    logger.info "user: #{self.screen_name} id: #{self.profile_id} | response message: #{response.message}"
    
    if response.message == "OK"
      json = response.body
      data = ActiveSupport::JSON.decode(json)
      unless data == []
        self.name = data.first['user']['name']
        self.profile_image_url = data.first['user']['profile_image_url']
        self.url = data.first['user']['url']
        self.description = data.first['user']['description']
        self.listed_count = data.first['user']['listed_count']
        self.followers_count = data.first['user']['followers_count']
        self.friends_count = data.first['user']['friends_count']
        self.statuses_count = data.first['user']['statuses_count']
        self.screen_name = data.first['user']['screen_name']
        self.save
        
        data.each do |ele|  
          id = ele['id']
          twitt = self.twitts.find_by_twitt_id(id)
      
          unless twitt
            content = ele['text']
            logger.info content
            text = preprocess(content)

            if check_if_polish(text)        
              twitt = Twitt.new
              twitt.body = content
              twitt.originally_created = ele['created_at'].to_datetime
              twitt.twitt_id = ele['id']
              twitt.source = ele['source']
              twitt.twitter_user_id = self.id
              twitt.save
            end
          end
        end
      else
        # no tweets
      end
    else
      # response error
    end
  end
  
  def fetch_new_users
    #friends_url = "http://api.twitter.com/1/statuses/friends.json?user_id=#{self.profile_id}"
    followers_url = "http://api.twitter.com/1/statuses/followers.json?user_id=#{self.profile_id}"
    
    #fetch(friends_url)
    fetch(followers_url)
  end
  
  private
  
  def fetch(url)
    response = Net::HTTP.get_response(URI.parse(url))
    logger.info "url: #{url} | response message: #{response.message}"
    json = response.body
    begin
      data = ActiveSupport::JSON.decode(json)
      unless data == []
        if response.message == "OK"
          data.each do |ele|
            id = ele['id']
            user = TwitterUser.find_by_profile_id(id)
            unless user
              tweet = ele['status']['text'] if ele['status']
              logger.info tweet
              text = preprocess(tweet)
              if text and check_if_polish(text)
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
                
                twitt = Twitt.new
                twitt.body = tweet
                twitt.originally_created = ele['status']['created_at'].to_datetime
                twitt.twitt_id = ele['status']['id']
                twitt.source = ele['status']['source']
                twitt.twitter_user_id = user.id
                twitt.save
              end
            end
          end
        else
          # response error
        end
      else
        # empty data
      end
    rescue
      # Invalide JSON string
      logger.error "JSON error while fetching #{url}"
    end
  end
  
  def update_total_users
    total = Setting.find_by_name('total_users')
    new_value = TwitterUser.verified.size
    total.update_attribute(:value, new_value) if total
  end
end
