module NLP
  
  def preprocess(text)
    text = text.lstrip
    text = text.downcase
    text = text.gsub(/http:\/\/[^ ]*/,'')
    text = text.gsub(/@[^ ]*/,'')
    text = text.gsub(/^rt /,'')        
    text = text.gsub(/ rt /,'')
    text = text.gsub(/[0-9]/,'')        
    text = text.gsub(/[^\w ]/,' ')
    text = text.gsub(/[' ']+/,'_')
    return text
  end
  
  def create_ngrams(text, max)
    table = text.split(//)
    @ngrams = {}
      
    max -= 1
    (1..max).each { |i| slice(table, 0, i) }
    ngrams = @ngrams.sort { |a,b| b[1] <=> a[1] }
    return ngrams
  end
  
  def slice(table, i, j) 
    until j == table.size
      ele = table[i..j].to_s
      if @ngrams[ele]
        @ngrams[ele] += 1
      else
        @ngrams[ele] = 1
      end
      i += 1
      j += 1
    end
  end
  
  def measure_density(test_ngrams, lang_ngrams)    
    if test_ngrams == []
      density = 0
    else    
      count = 0
    
      test_ngrams.each do |ele|
        count += 1 if lang_ngrams.include?(ele)
      end
      
      total = test_ngrams.size
      density = count.to_f / total.to_f
    end
  end
  
  def check_if_polish(text) 
    if text != '' and text != '_' and text.size > 3
      ngrams = create_ngrams(text, 3)
      test_ngrams = []

      ngrams.each do |ele|
        test_ngrams << ele.first + ';'
      end
      
      pol_sample ||= Sample.find_by_language("Polish")
      pol_ngrams ||= pol_sample.ngram.body.split(/[\d]* - /)

      density = measure_density(test_ngrams, pol_ngrams)
      logger.info "Density: #{density}"
      value ||= Setting.find_by_name("density").value
      density > value ? true : false
    else
      return false
    end
  end
  
  def check_category
    tab = self.body.downcase.split
    tab.delete_if {|ele| ele.length == 1 }
    total = {}
    tab.each do |word| 
      word.gsub!(/[^a-ząęóśźćżłń]/,'')
      Rule.all.each do |rule|
        cat = rule.category
        if rule.filter.split(', ').include? word
          total[cat] = 0
        else
          total[cat] = 0 if total[cat].nil?
          total[cat] += rule.word_weight if rule.word.split(', ').include? word
          total[cat] += rule.synonymy_weight if rule.synonymy.split(', ').include? word
          total[cat] += rule.is_a_weight if rule.is_a.split(', ').include? word
          total[cat] += rule.similar_to_weight if rule.similar_to.split(', ').include? word
          total[cat] += rule.is_a_part_of_weight if rule.is_a_part_of.split(', ').include? word
          total[cat] += rule.consists_of_weight if rule.consists_of.split(', ').include? word
          total[cat] += rule.destination_weight if rule.destination.split(', ').include? word
        end
      end
    end
    best = total.invert.sort.last
    if best[0] > 0
      self.update_attribute(:category, best[1])
    else
      self.update_attribute(:category, nil)
    end
  end
end

