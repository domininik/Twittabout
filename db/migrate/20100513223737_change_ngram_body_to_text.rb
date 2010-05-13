class ChangeNgramBodyToText < ActiveRecord::Migration
  def self.up
    change_column :ngrams, :body, :text
  end

  def self.down
    change_column :ngrams, :body, :string
  end
end
