class NgramsController < ApplicationController
  before_filter :get_sample
  include NLP
  
  def show
    @pre = preprocess(@sample.body).gsub('_', ' ')

    respond_to do |format|
      format.html
    end
  end

  def generate_ngrams
    ngram = @sample.ngram
    ngram.destroy if ngram
        
    @pre = text = preprocess(@sample.body)
    if text == ""
      Ngram.create(:sample_id => @sample.id, :body => "")
      flash[:notice] = "All characters in the text are non-latin!"
    else  
      max = params[:max].to_i
 
      if max > text.length
        flash[:error] = "N can't be bigger than preprocessed text"
      else 
        ngrams = create_ngrams(text, max)

        foo = []
        ngrams.each do |ele|
          foo << "#{ele[1]} - #{ele[0]};"
        end
        
        Ngram.create(:sample_id => @sample.id, :body => foo.to_s)
        flash[:notice] = "Generated #{ngrams.size} N-grams for N = #{params[:max]}"
      end
    end
    redirect_to sample_ngram_path(@sample)
  end
    
  private
  
  def get_sample
    @sample = Sample.find(params[:sample_id])
  end
  
end
