class HomeController < ApplicationController
  def index
    @title = ""
    get_twitts
    @users = TwitterUser.all(:order => "followers_count DESC")
    
    respond_to do |format|
      format.html {}
    end
  end

end
