class AddCategoryToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :category, :string
  end

  def self.down
    remove_column :samples, :category
  end
end
