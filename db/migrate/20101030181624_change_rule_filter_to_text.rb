class ChangeRuleFilterToText < ActiveRecord::Migration
  def self.up
    change_column :rules, :filter, :text
  end

  def self.down
    change_column :rules, :filter, :text
  end
end
