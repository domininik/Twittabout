class NgramsController < ApplicationController
  before_filter :get_sample
  
  def show
    @pre = preprocess(@sample.body).gsub('_', ' ')

    respond_to do |format|
      format.html
    end
  end

  def generate_ngram
    ngram = @sample.ngram
    ngram.destroy if ngram
    text = preprocess(@sample.body)
    if text = ""
      Ngram.create(:sample_id => @sample.id, :body => "")
      flash[:notice] = "All characters in the text are non-latin!"
    else
      table = text.split(//)
    
      # N=1
      @ngrams = {}
    
      table.each do |ele|
        if @ngrams[ele]
          @ngrams[ele] += 1
        else
          @ngrams[ele] = 1
        end
      end
          
      max = params[:max].to_i
 
      if max > text.length
        flash[:error] = "N can't be bigger than preprocessed text"
      else
        max -= 1
        (1..max).each { |i| slice(table, 0, i) }
        @ngrams = @ngrams.sort { |a,b| b[1] <=> a[1] }
        foo = []
        @ngrams.each do |ele|
          foo << "#{ele[1]} - #{ele[0]};"
        end
        Ngram.create(:sample_id => @sample.id, :body => foo.to_s)
      
        flash[:notice] = "Generated #{@ngrams.size} N-grams for N = #{params[:max]}"
      end
    end
    redirect_to sample_ngram_path(@sample)
  end
    
  private
  
  def get_sample
    @sample = Sample.find(params[:sample_id])
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
  
  def preprocess(text)
    text = text.lstrip
    text = text.downcase
    text = text.delete "^[a-z]"
    text = text.delete "^[ąęóśźćżłń]"
    text = text.gsub(' ','_')
    @pre = text
  end
  
end
