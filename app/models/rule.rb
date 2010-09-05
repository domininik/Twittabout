class Rule < ActiveRecord::Base
  def total_weight
    self.word_weight + self.synonymy_weight + self.is_a_weight + self.similar_to_weight + self.is_a_part_of_weight + self.consists_of_weight + self.destination_weight
  end
end
