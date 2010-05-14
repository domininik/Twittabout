class CandidatesController < ApplicationController
  Komorowski = {:name => "Bronisław Komorowski", :id => "138163716"}
  Olechowski = {:name => "Andrzej Olechowski", :id => "77598783"}
  Napieralski = {:name => "Grzegorz Napieralski", :id => "129166436"}
  Jurek = {:name => "Marek Jurek", :id => "125404928"}
  Mikke = {:name => "Janusz Korwin-Mikke", :id => "59603734"}
  Morawiecki = {:name => "Kornel Morawiecki", :id => "138184708"}
  
  def index
    #feed_all
    #get_all_profile_pics
    @twitts_5 = Twitt.find_all_by_username("Bronisław Komorowski", :order => "date DESC")
    @avatar_5 = Twittpic.find_by_user_id(Komorowski[:id])
    @twitts_1 = Twitt.find_all_by_username("Andrzej Olechowski", :order => "date DESC")
    @avatar_1 = Twittpic.find_by_user_id(Olechowski[:id])
    @twitts_3 = Twitt.find_all_by_username("Grzegorz Napieralski", :order => "date DESC")
    @avatar_3 = Twittpic.find_by_user_id(Napieralski[:id])
    @twitts_2 = Twitt.find_all_by_username("Marek Jurek", :order => "date DESC")
    @avatar_2 = Twittpic.find_by_user_id(Jurek[:id])
    @twitts_6 = Twitt.find_all_by_username("Janusz Korwin-Mikke", :order => "date DESC")
    @avatar_6 = Twittpic.find_by_user_id(Mikke[:id])
    @twitts_4 = Twitt.find_all_by_username("Kornel Morawiecki", :order => "date DESC")
    @avatar_4 = Twittpic.find_by_user_id(Morawiecki[:id])
  end

  private
  
  def feed_all
    feed(Komorowski[:id], Komorowski[:name])
    feed(Olechowski[:id], Olechowski[:name])
    feed(Napieralski[:id], Napieralski[:name])
    feed(Jurek[:id], Jurek[:name])
    feed(Mikke[:id], Mikke[:name])
    feed(Morawiecki[:id], Morawiecki[:name])
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
  
  def get_all_profile_pics
    get_profile_pic(Komorowski[:id])
    get_profile_pic(Olechowski[:id])
    get_profile_pic(Napieralski[:id])
    get_profile_pic(Jurek[:id])
    get_profile_pic(Mikke[:id])
    get_profile_pic(Morawiecki[:id])
  end
  
  def get_profile_pic(id)
    url = "http://api.twitter.com/1/users/show.xml?id=#{id}"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    doc.elements.each('user') do |ele|
      twittpic = Twittpic.new
      twittpic.user_id = id
      twittpic.url = ele.elements['profile_image_url'].text
      debugger
      twittpic.save
    end
  end
end
