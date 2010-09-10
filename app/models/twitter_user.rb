class TwitterUser < ActiveRecord::Base
  has_many :twitts, :dependent => :destroy
  def to_param
    "#{id}-#{screen_name}"
  end
end
