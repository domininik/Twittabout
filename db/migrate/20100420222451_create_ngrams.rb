class CreateNgrams < ActiveRecord::Migration
  def self.up
    create_table :ngrams do |t|
      t.string :body
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :ngrams
  end
end
