class ChangeTwittTwittIdToBiginteger < ActiveRecord::Migration
  def self.up
    change_column :twitts, :twitt_id, :bigint
  end

  def self.down
    change_column :twitts, :twitt_id, :integer
  end
end
