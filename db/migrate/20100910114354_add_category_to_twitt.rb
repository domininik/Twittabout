class AddCategoryToTwitt < ActiveRecord::Migration
  def self.up
    add_column :twitts, :category, :string
  end

  def self.down
    remove_column :twitts, :category
  end
end
