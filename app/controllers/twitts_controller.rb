class TwittsController < ApplicationController
  before_filter :require_user

  def index
    respond_to do |format|
      format.html {}
    end
  end 

  def feed
    @twitts = []
    url = 'http://api.twitter.com/statuses/public_timeline.json'
    json = Net::HTTP.get_response(URI.parse(url)).body
    data = ActiveSupport::JSON.decode(json)
    data.each do |ele|
      @twitts << ele['text']
    end
   
    respond_to do |format|
      format.html {
        render :template => 'twitts/index'
      }
    end
  end

end
