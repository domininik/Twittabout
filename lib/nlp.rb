module NLP
  Density = 0.89
  
  def preprocess(text)
    text = text.lstrip
    text = text.downcase
    text = text.gsub(/[^a-ząęóśźćżłń ]/,' ')
    text = text.gsub(/[' ']+/,'_')
    return text
  end
  
  def create_ngrams(text, max)
    table = text.split(//)
    @ngrams = {}

    table.each do |ele|
      if @ngrams[ele]
        @ngrams[ele] += 1
      else
        @ngrams[ele] = 1
      end
    end
      
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
    if text != '' and text != '_' and text.size > 2
      ngrams = create_ngrams(text, 3)
      test_ngrams = []

      ngrams.each do |ele|
        test_ngrams << ele.first + ';'
      end
      
      pol_sample ||= Sample.find_by_language("Polish")
      pol_ngrams ||= pol_sample.ngram.body.split(/[\d]* - /)

      density = measure_density(test_ngrams, pol_ngrams)
      puts "Density: #{density}"
      density > Density ? true : false
    else
      return false
    end
  end
end