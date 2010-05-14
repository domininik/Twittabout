class CreateTwittpics < ActiveRecord::Migration
  def self.up
    create_table :twittpics do |t|
      t.integer :user_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :twittpics
  end
end
