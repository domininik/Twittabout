class CandidatesController < ApplicationController
  Komorowski = {:name => "Bronisław Komorowski", :id => "138163716"}
  Olechowski = {:name => "Andrzej Olechowski", :id => "77598783"}
  Napieralski = {:name => "Grzegorz Napieralski", :id => "129166436"}
  Jurek = {:name => "Marek Jurek", :id => "125404928"}
  Mikke = {:name => "Janusz Korwin-Mikke", :id => "142395887"}
  Morawiecki = {:name => "Kornel Morawiecki", :id => "138184708"}
  Kaczynski = {:name => "Jarosław Kaczyński", :id => "141919655"}
  
  def index
    #cache = ActiveSupport::Cache::MemCacheStore.new
    
    feed_all
    get_all_profile_pics if Twittpic.all == []

    @twitts_1 = Twitt.find_all_by_username("Andrzej Olechowski", :order => "date DESC")
    @avatar_1 = Twittpic.find_by_user_id(Olechowski[:id])
    
    @twitts_2 = Twitt.find_all_by_username("Grzegorz Napieralski", :order => "date DESC")
    @avatar_2 = Twittpic.find_by_user_id(Napieralski[:id])
    
    @twitts_3 = Twitt.find_all_by_username("Bronisław Komorowski", :order => "date DESC")
    @avatar_3 = Twittpic.find_by_user_id(Komorowski[:id])
    
    @twitts_4 = Twitt.find_all_by_username("Jarosław Kaczyński", :order => "date DESC")
    @avatar_4 = Twittpic.find_by_user_id(Kaczynski[:id])
    
    @twitts_5 = Twitt.find_all_by_username("Janusz Korwin-Mikke", :order => "date DESC")
    @avatar_5 = Twittpic.find_by_user_id(Mikke[:id])
    
    @twitts_6 = Twitt.find_all_by_username("Marek Jurek", :order => "date DESC")
    @avatar_6 = Twittpic.find_by_user_id(Jurek[:id])
    
    @twitts_7 = Twitt.find_all_by_username("Kornel Morawiecki", :order => "date DESC")
    @avatar_7 = Twittpic.find_by_user_id(Morawiecki[:id])
  end
  
  def get_all_profile_pics
    Twittpic.destroy_all
    get_profile_pic(Komorowski[:id])
    get_profile_pic(Olechowski[:id])
    get_profile_pic(Napieralski[:id])
    get_profile_pic(Jurek[:id])
    get_profile_pic(Mikke[:id])
    get_profile_pic(Morawiecki[:id])
    get_profile_pic(Kaczynski[:id])

    respond_to do |format|
      format.html {
        redirect_to candidates_path
      }
    end
  end

  private
  
  def feed_all
    feed(Komorowski[:id], Komorowski[:name])
    feed(Olechowski[:id], Olechowski[:name])
    feed(Napieralski[:id], Napieralski[:name])
    feed(Jurek[:id], Jurek[:name])
    feed(Mikke[:id], Mikke[:name])
    feed(Morawiecki[:id], Morawiecki[:name])
    feed(Kaczynski[:id], Kaczynski[:name])
  end
  
  def feed(id, name)
    url = "http://api.twitter.com/statuses/user_timeline/#{id}.xml"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    doc.elements.each('statuses/status') do |ele|
      twitt_id = ele.elements['id'].text.to_i
      twitt = Twitt.find_by_twitt_id(twitt_id)
      if twitt
        break
      else
        twitt = Twitt.new
        twitt.twitt_id = twitt_id
        twitt.date = ele.elements['created_at'].text
        twitt.body = ele.elements['text'].text
        twitt.username = name
        twitt.save
      end
    end          
  end
  
  def get_profile_pic(id)
    url = "http://api.twitter.com/1/users/show.xml?id=#{id}"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    doc.elements.each('user') do |ele|
      twittpic = Twittpic.new
      twittpic.user_id = id
      twittpic.url = ele.elements['profile_image_url'].text
      twittpic.save
    end
  end
end
