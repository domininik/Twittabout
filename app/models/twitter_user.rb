class TwitterUser < ActiveRecord::Base
  has_many :twitts, :dependent => :destroy
end
