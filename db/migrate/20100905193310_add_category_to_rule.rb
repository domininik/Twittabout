class AddCategoryToRule < ActiveRecord::Migration
  def self.up
    add_column :rules, :category, :string
  end

  def self.down
    remove_column :rules, :category
  end
end
