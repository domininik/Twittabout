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
  
  def analyze_a
    @sample = Sample.find(params[:sample_id])
    @test_ngrams = @sample.ngram
    @eng_sample = Sample.find_by_language("English")
    @pol_sample = Sample.find_by_language("Polish")
    
    if @test_ngrams == [] or @test_ngrams.nil?
      flash[:error] = "You have to generate N-grams first"
      redirect_to(@sample)
    elsif @eng_sample == [] or @eng_sample.nil?
      flash[:error] = "There is no sample English text"
      redirect_to(samples_path)
    elsif @pol_sample == [] or @pol_sample.nil?
      flash[:error] = "There is no sample Polish text"
      redirect_to(samples_path)
    else
      @eng_ngrams = @eng_sample.ngram
      @pol_ngrams = @pol_sample.ngram
      
      if @eng_ngrams == [] or @eng_ngrams.nil?
        flash[:error] = "Please, generate N-grams for English sample text"
        redirect_to sample_ngram_path(@eng_sample)
      elsif @pol_ngrams == [] or @pol_ngrams.nil?
        flash[:error] = "Please, generate N-grams for Polish sample text"
        redirect_to sample_ngram_path(@pol_sample)
      else
        @max_distance = params[:max_distance].to_i
      
        pol_counter = measure_distance(@test_ngrams, @pol_ngrams, @max_distance)
        eng_counter = measure_distance(@test_ngrams, @eng_ngrams, @max_distance)

        if pol_counter < eng_counter 
          flash[:notice] = "pol: #{pol_counter} | eng: #{eng_counter} <br />Text in Polish"
        else
          flash[:notice] = "pol: #{pol_counter} | eng: #{eng_counter} <br />Text not in Polish"
        end
        redirect_to(@sample)
      end
       
    end
  end
  
  def analyze_b
    @sample = Sample.find(params[:sample_id])
    @test_ngrams = @sample.ngram
    @pol_sample = Sample.find_by_language("Polish")
    
    if @test_ngrams == [] or @test_ngrams.nil?
      flash[:error] = "You have to generate N-grams first"
      redirect_to(@sample)
    elsif @pol_sample == [] or @pol_sample.nil?
      flash[:error] = "There is no sample Polish text"
      redirect_to(samples_path)
    else
      @pol_ngrams = @pol_sample.ngram
      
      if @pol_ngrams == [] or @pol_ngrams.nil?
        flash[:error] = "Please, generate N-grams for Polish sample text"
        redirect_to sample_ngram_path(@pol_sample)
      else
        density = measure_density(@test_ngrams, @pol_ngrams)

        flash[:notice] = "Density: #{density}"

        redirect_to(@sample)
      end
       
    end
  end
  
  private
  
  def set_options
    @languages = {"Polish" => "Polish", "English" => "English", "Unknown" => ""}
  end
  
  def measure_distance(test_ngrams, lang_ngrams, max_distance)
    lang_counter = 0
    
    # make an array
    test_ngrams = test_ngrams.body.split(/[\d]* - /)
    lang_ngrams = lang_ngrams.body.split(/[\d]* - /)
        
    test_ngrams.each do |ele|
      test_position = test_ngrams.index(ele)
      lang_position = lang_ngrams.index(ele)
            
      if lang_position
        lang_counter += lang_position - test_position
      else
        lang_counter += max_distance
      end
    end
    return lang_counter
  end
  
  def measure_density(test_ngrams, lang_ngrams)
    test_ngrams = test_ngrams.body.split(/[\d]* - /)
    lang_ngrams = lang_ngrams.body.split(/[\d]* - /)
    
    count = 0
    
    test_ngrams.each do |ele|
      count += 1 if lang_ngrams.include?(ele)
    end
    
    total = test_ngrams.size
    
    density = count.to_f / total.to_f
  end
  
end
