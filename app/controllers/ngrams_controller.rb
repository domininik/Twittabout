class NgramsController < ApplicationController
  before_filter :get_sample
  
  def index
    preprocess(@sample.body)
    #@ngrams = Ngram.find(:all, :conditions => "sample_id = 3", :order => "count DESC")
    @ngrams = @sample.ngrams.find(:all, :order => "count DESC")

    respond_to do |format|
      format.html
    end
  end

  def generate_ngram
    text = preprocess(@sample.body)
    table = text.split(//)
    
    # N=1
    table.each do |ele|
      ngram = Ngram.find_or_create_by_body_and_sample_id(ele, @sample.id)
      if ngram.count.nil?
        ngram.update_attribute(:count, 1)
      else
        ngram.count += 1
      end
      ngram.sample_id = @sample.id
      ngram.save
    end
    # N=2, N=3
    (1..2).each { |i| slice(table, 0, i) }
            
    respond_to do |format|
      format.html {
        redirect_to sample_ngrams_path(@sample)
      }
    end
  end
  
  def destroy_all
    Ngram.delete_all("sample_id = #{@sample.id}")
    
    respond_to do |format|
      format.html {
        redirect_to sample_ngrams_path(@sample)
      }
    end
  end
  
  private
  
  def get_sample
    @sample = Sample.find(params[:sample_id])
  end
  
  def slice(table, i, j) 
    until j == table.size
      ele = table[i..j].to_s
      ngram = Ngram.find_or_create_by_body_and_sample_id(ele, @sample.id)
      if ngram.count.nil?
        ngram.update_attribute(:count, 1)
      else
        ngram.count += 1
      end
      ngram.sample_id = @sample.id
      ngram.save
      i += 1
      j += 1
    end
  end
  
  def preprocess(text)
    text = text.lstrip
    text = text.downcase
    text = text.delete "^[a-z ąęóśźćżłń]"
    text = text.gsub(' ','_')
    @pre = text
  end
  
end
