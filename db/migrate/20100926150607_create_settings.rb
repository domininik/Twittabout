class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.float :value

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
