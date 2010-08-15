class TwittsController < ApplicationController
  before_filter :require_user
  def index
    respond_to do |format|
      format.html {}
    end
  end 

  def feed
    @twitts = []
    url = 'http://api.twitter.com/statuses/public_timeline.xml'
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    doc.elements.each('statuses/status') do |ele|
      @twitts << ele.elements['text'].text
    end
    
    respond_to do |format|
      format.html {
        render :template => 'twitts/index'
      }
    end
  end

end
