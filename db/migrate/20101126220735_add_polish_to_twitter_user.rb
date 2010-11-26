class AddPolishToTwitterUser < ActiveRecord::Migration
  def self.up
    add_column :twitter_users, :polish, :boolean
  end

  def self.down
    remove_column :twitter_users, :polish
  end
end
