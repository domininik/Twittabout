class AddUsernameToTwitt < ActiveRecord::Migration
  def self.up
    add_column :twitts, :username, :string
  end

  def self.down
    remove_column :twitts, :username
  end
end
