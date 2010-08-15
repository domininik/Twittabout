module NgramsHelper
  def format(text)
    text = text.gsub(';', "<br />")
  end
  
  def ngrams_size(sample)
    if n = sample.ngram
      n.body.split(';').size
    else
      return 0
    end  
  end
end
