# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100908200914) do

  create_table "items", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ngrams", :force => true do |t|
    t.text     "body",       :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sample_id"
  end

  create_table "rules", :force => true do |t|
    t.string   "word"
    t.integer  "word_weight",         :default => 0
    t.text     "synonymy"
    t.integer  "synonymy_weight",     :default => 0
    t.text     "is_a"
    t.integer  "is_a_weight",         :default => 0
    t.text     "similar_to"
    t.integer  "similar_to_weight",   :default => 0
    t.text     "is_a_part_of"
    t.integer  "is_a_part_of_weight", :default => 0
    t.text     "consists_of"
    t.integer  "consists_of_weight",  :default => 0
    t.text     "destination"
    t.integer  "destination_weight",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "samples", :force => true do |t|
    t.string   "language"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "name"
    t.string   "profile_image_url"
    t.string   "url"
    t.integer  "profile_id"
    t.integer  "listed_count"
    t.integer  "followers_count"
    t.string   "description"
    t.integer  "statuses_count"
    t.integer  "friends_count"
    t.string   "screen_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twittpics", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitts", :force => true do |t|
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitt_id",           :limit => 8
    t.datetime "date"
    t.string   "username"
    t.string   "source"
    t.integer  "twitter_user_id"
    t.datetime "originally_created"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
