class AddSampleIdToNgram < ActiveRecord::Migration
  def self.up
    add_column :ngrams, :sample_id, :integer
  end

  def self.down
    remove_column :ngrams, :sample_id
  end
end
