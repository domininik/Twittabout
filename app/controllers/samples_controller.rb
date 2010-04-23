class SamplesController < ApplicationController
  before_filter :require_user
  # TODO MAX
  MAX = 10000
  
  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.all

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
    @eng_ngrams = @eng_sample.ngrams.find(:all, :order => "count DESC")
    @pol_sample = Sample.find_by_language("Polish")
    @pol_ngrams = @pol_sample.ngrams.find(:all, :order => "count DESC")
    
    @eng_counter = 0
    @test_ngrams.each do |ele|
      # TODO each_with_index?
      test_position = @test_ngrams.index(ele)
      ngram = Ngram.find(:first, :conditions => "body = '#{ele.body}' and sample_id = #{@eng_sample.id}") 
      if ngram
        eng_position = @eng_ngrams.index(ngram)
        @eng_counter += eng_position - test_position
      else
        @eng_counter += MAX
      end
    end

    @pol_counter = 0
    @test_ngrams.each do |ele|
      # TODO each_with_index?
      test_position = @test_ngrams.index(ele)
      ngram = Ngram.find(:first, :conditions => "body = '#{ele.body}' and sample_id = #{@pol_sample.id}") 
      if ngram
        pol_position = @pol_ngrams.index(ngram)
        @pol_counter += pol_position - test_position
      else
        @pol_counter += MAX
      end
    end
    
    respond_to do |format|
      format.html {
        if @pol_counter < @eng_counter 
          flash[:notice] = "pol: #{@pol_counter} | eng: #{@eng_counter} <br />Text in Polish"
        else
          flash[:notice] = "pol: #{@pol_counter} | eng: #{@eng_counter} <br />Text not in Polish"
        end
        redirect_to(@sample) 
      }
      format.xml  { render :xml => @sample }
    end
  end
end
