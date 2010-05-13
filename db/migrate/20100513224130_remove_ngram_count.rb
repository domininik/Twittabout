class RemoveNgramCount < ActiveRecord::Migration
  def self.up
    remove_column :ngrams, :count
  end

  def self.down
    add_column :ngrams, :count, :integer
  end
end
