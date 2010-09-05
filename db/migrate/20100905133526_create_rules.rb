class CreateRules < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.string :word
      t.integer :word_weight
      t.text :synonymy
      t.integer :synonymy_weight
      t.text :is_a
      t.integer :is_a_weight
      t.text :similar_to
      t.integer :similar_to_weight
      t.text :is_a_part_of
      t.integer :is_a_part_of_weight
      t.text :consists_of
      t.integer :consists_of_weight
      t.text :destination
      t.integer :destination_weight

      t.timestamps
    end
  end

  def self.down
    drop_table :rules
  end
end
