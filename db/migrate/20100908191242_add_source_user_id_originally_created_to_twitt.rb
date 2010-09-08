class AddSourceUserIdOriginallyCreatedToTwitt < ActiveRecord::Migration
  def self.up
    add_column :twitts, :source, :string
    add_column :twitts, :user_id, :integer
    add_column :twitts, :originally_created, :datetime
  end

  def self.down
    remove_column :twitts, :originally_created
    remove_column :twitts, :user_id
    remove_column :twitts, :source
  end
end
