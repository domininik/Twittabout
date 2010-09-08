class CreateTwitterUsers < ActiveRecord::Migration
  def self.up
    create_table :twitter_users do |t|
      t.string :name
      t.string :profile_image_url
      t.string :url
      t.integer :profile_id
      t.integer :listed_count
      t.integer :followers_count
      t.string :description
      t.integer :statuses_count
      t.integer :friends_count
      t.string :screen_name

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_users
  end
end
