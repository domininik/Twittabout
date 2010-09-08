class TwitterUser < ActiveRecord::Base
  has_many :twitts
end
