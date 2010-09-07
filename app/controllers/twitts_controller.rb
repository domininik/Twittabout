class TwittsController < ApplicationController
  before_filter :require_user
  include NLP

  def index
    @twitts = Twitt.all
    respond_to do |format|
      format.html {}
    end
  end 

  def feed
    url = 'http://api.twitter.com/statuses/public_timeline.json'
    json = Net::HTTP.get_response(URI.parse(url)).body
    data = ActiveSupport::JSON.decode(json)
    data.each do |ele|
      content = ele['text']
      puts content
      puts '**********'
      text = preprocess(content)
      Twitt.create(:body => content) if check_if_polish(text)
    end
   
    respond_to do |format|
      format.html {
        redirect_to twitts_path
      }
    end
  end

end
