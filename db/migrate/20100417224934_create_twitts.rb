class CreateTwitts < ActiveRecord::Migration
  def self.up
    create_table :twitts do |t|
      t.string :body

      t.timestamps
    end
  end

  def self.down
    drop_table :twitts
  end
end
