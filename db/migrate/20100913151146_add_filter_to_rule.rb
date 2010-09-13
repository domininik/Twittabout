class AddFilterToRule < ActiveRecord::Migration
  def self.up
    add_column :rules, :filter, :string
  end

  def self.down
    remove_column :rules, :filter
  end
end
