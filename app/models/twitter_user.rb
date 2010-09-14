class TwitterUser < ActiveRecord::Base
  has_many :twitts, :dependent => :destroy
  include NLP

  def to_param
    "#{id}-#{screen_name}"
  end
  
  def latest_tweet
    Twitt.all(:conditions => "twitter_user_id = #{self.id}", :order => "originally_created DESC").first
  end
  
  def update_data
    url = "http://api.twitter.com/1/statuses/user_timeline.json?user_id=#{self.profile_id}"
    response = Net::HTTP.get_response(URI.parse(url))

    if response.message == "OK"
      json = response.body
      data = ActiveSupport::JSON.decode(json)
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
          puts content
          text = preprocess(content)

          #if content.length.to_f / text.length.to_f < 2.0
            if check_if_polish(text)        
              twitt = Twitt.new
              twitt.body = content
              twitt.originally_created = ele['created_at'].to_datetime
              twitt.twitt_id = ele['id']
              twitt.source = ele['source']
              twitt.twitter_user_id = self.id
              twitt.save
            end
          #end
        end
      end
    end
  end
  
end
