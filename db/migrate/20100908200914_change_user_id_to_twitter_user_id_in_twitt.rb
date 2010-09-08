class ChangeUserIdToTwitterUserIdInTwitt < ActiveRecord::Migration
  def self.up
    rename_column :twitts, :user_id, :twitter_user_id
  end

  def self.down
    rename_column :twitts, :twitter_user_id, :user_id
  end
end
