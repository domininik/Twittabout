class AddTwittIdAndTimeToTwitt < ActiveRecord::Migration
  def self.up
    add_column :twitts, :twitt_id, :integer
    add_column :twitts, :date, :datetime
  end

  def self.down
    remove_column :twitts, :date
    remove_column :twitts, :twitt_id
  end
end
