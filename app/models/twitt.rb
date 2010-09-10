class Twitt < ActiveRecord::Base
  belongs_to :twitter_user
  include NLP

  def avatar
    self.twitter_user.profile_image_url
  end  
end
