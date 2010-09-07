class Sample < ActiveRecord::Base
  has_one :ngram, :dependent => :destroy
end
