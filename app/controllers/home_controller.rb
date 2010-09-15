class HomeController < ApplicationController
  def index
    @title = "Tweety napisane po polsku"
    get_twitts
    @me ||= TwitterUser.find_by_profile_id(104234338)
    @my_twitts ||= Twitt.all(:conditions => "twitter_user_id = #{@me.id}", :order => "originally_created DESC", :limit => 3) if @me
    @users ||= TwitterUser.all(:order => "followers_count DESC", :limit => 8)
    @all_users_size ||= TwitterUser.all.size
    respond_to do |format|
      format.html {}
    end
  end

  def info
  end
end
