class SamplesController < ApplicationController
  before_filter :require_user
  before_filter :set_options, :only => [:new, :edit]
  
  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.find(:all, :order => "language DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @samples }
    end
  end

  # GET /samples/1
  # GET /samples/1.xml
  def show
    @sample = Sample.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sample }
    end
  end

  # GET /samples/new
  # GET /samples/new.xml
  def new
    @sample = Sample.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sample }
    end
  end

  # GET /samples/1/edit
  def edit
    @sample = Sample.find(params[:id])
  end

  # POST /samples
  # POST /samples.xml
  def create
    @sample = Sample.new(params[:sample])

    respond_to do |format|
      if @sample.save
        flash[:notice] = 'Sample was successfully created.'
        format.html { redirect_to(@sample) }
        format.xml  { render :xml => @sample, :status => :created, :location => @sample }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /samples/1
  # PUT /samples/1.xml
  def update
    @sample = Sample.find(params[:id])

    respond_to do |format|
      if @sample.update_attributes(params[:sample])
        flash[:notice] = 'Sample was successfully updated.'
        format.html { redirect_to(@sample) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.xml
  def destroy
    @sample = Sample.find(params[:id])
    @sample.destroy

    respond_to do |format|
      format.html { redirect_to(samples_url) }
      format.xml  { head :ok }
    end
  end
  
  def analyze
    @sample = Sample.find(params[:sample_id])
    @test_ngrams = @sample.ngrams.find(:all, :order => "count DESC")
    @eng_sample = Sample.find_by_language("English")
    @pol_sample = Sample.find_by_language("Polish")
    
    respond_to do |format|
      format.html {
        if @test_ngrams == []
          flash[:error] = "You have to generate N-grams first"
          redirect_to(@sample)
        elsif @eng_sample == [] or @eng_sample.nil?
          flash[:error] = "There is no sample English text"
          redirect_to(samples_path)
        elsif @pol_sample == [] or @pol_sample.nil?
          flash[:error] = "There is no sample Polish text"
          redirect_to(samples_path)
        else
          @eng_ngrams = @eng_sample.ngrams.find(:all, :order => "count DESC")
          @pol_ngrams = @pol_sample.ngrams.find(:all, :order => "count DESC")
          @max_distance = params[:max_distance].to_i
          
          pol_counter = count_distance(@test_ngrams, @pol_ngrams, @pol_sample.id, @max_distance)
          eng_counter = count_distance(@test_ngrams, @eng_ngrams, @eng_sample.id, @max_distance)
    
          if pol_counter < eng_counter 
            flash[:notice] = "pol: #{pol_counter} | eng: #{eng_counter} <br />Text in Polish"
          else
            flash[:notice] = "pol: #{pol_counter} | eng: #{eng_counter} <br />Text not in Polish"
          end
          redirect_to(@sample) 
        end
      }
      format.xml  { render :xml => @sample }
    end
  end
  
  def count_distance(test_ngrams, lang_ngrams, lang_sample_id, max_distance)
    lang_counter = 0
    @test_ngrams.each do |ele|
      test_position = @test_ngrams.index(ele)
      ngram = Ngram.find(:first, :conditions => "body = '#{ele.body}' and sample_id = #{lang_sample_id}") 
      if ngram
        lang_position = lang_ngrams.index(ngram)
        lang_counter += lang_position - test_position
      else
        lang_counter += max_distance
      end
    end
    return lang_counter
  end
  
  private
  
  def set_options
    @languages = {"Polish" => "Polish", "English" => "English", "Unknown" => ""}
  end
  
end
