class CandidatesController < ApplicationController
  Komorowski = {:name => "Bronisław Komorowski", :id => "138163716"}
  Olechowski = {:name => "Andrzej Olechowski", :id => "77598783"}
  Napieralski = {:name => "Grzegorz Napieralski", :id => "129166436"}
  Jurek = {:name => "Marek Jurek", :id => "125404928"}
  Mikke = {:name => "Janusz Korwin-Mikke", :id => "142395887"}
  Morawiecki = {:name => "Kornel Morawiecki", :id => "138184708"}
  Kaczynski = {:name => "Jarosław Kaczyński", :id => "141919655"}
  Pawlak = {:name => "Waldemar Pawlak", :id => "143817832"}
  
  def index
    #cache = ActiveSupport::Cache::MemCacheStore.new
    
    #feed_all
    get_all_profile_pics if Twittpic.all == []
 
    @columns = 0
    
    unless cookies["1"]
      @twitts_1 = Twitt.find_all_by_username("Andrzej Olechowski", :order => "date DESC")
      @avatar_1 = Twittpic.find_by_user_id(Olechowski[:id])
      @columns += 1
    end
    
    unless cookies["2"]
      @twitts_2 = Twitt.find_all_by_username("Grzegorz Napieralski", :order => "date DESC")
      @avatar_2 = Twittpic.find_by_user_id(Napieralski[:id])
      @columns += 1
    end
    
    unless cookies["3"]
      @twitts_3 = Twitt.find_all_by_username("Bronisław Komorowski", :order => "date DESC")
      @avatar_3 = Twittpic.find_by_user_id(Komorowski[:id])
      @columns += 1
    end
    
    unless cookies["4"]
      @twitts_4 = Twitt.find_all_by_username("Jarosław Kaczyński", :order => "date DESC")
      @avatar_4 = Twittpic.find_by_user_id(Kaczynski[:id])
      @columns += 1
    end
    
    unless cookies["5"]
      @twitts_5 = Twitt.find_all_by_username("Waldemar Pawlak", :order => "date DESC")
      @avatar_5 = Twittpic.find_by_user_id(Pawlak[:id])
      @columns += 1
    end
    
    unless cookies["6"]
      @twitts_6 = Twitt.find_all_by_username("Janusz Korwin-Mikke", :order => "date DESC")
      @avatar_6 = Twittpic.find_by_user_id(Mikke[:id])
      @columns += 1
    end
    
    unless cookies["7"]
      @twitts_7 = Twitt.find_all_by_username("Marek Jurek", :order => "date DESC")
      @avatar_7 = Twittpic.find_by_user_id(Jurek[:id])
      @columns += 1
    end
    
    unless cookies["8"]
      @twitts_8 = Twitt.find_all_by_username("Kornel Morawiecki", :order => "date DESC")
      @avatar_8 = Twittpic.find_by_user_id(Morawiecki[:id])
      @columns += 1
    end
    
    set_column_width
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
    get_profile_pic(Pawlak[:id])

    respond_to do |format|
      format.html {
        redirect_to candidates_path
      }
    end
  end
  
  def hide
    cookies["#{params[:id]}"] = true
    
    respond_to do |format|
      format.html {
        redirect_to candidates_path
      }
    end   
  end
  
  def clear_cookies
    (1..10).each do |ele|
      cookies.delete "#{ele}"
    end
    
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
    feed(Pawlak[:id], Pawlak[:name])
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
  
  def set_column_width
    case @columns
    when 0
      @width = "100%"
    when 1
      @width = "98%"
    when 2
      @width = "48.5%"
    when 3
      @width = "32%"
    when 4
      @width = "23.5%"
    when 5
      @width = "18.5%"
    when 6
      @width = "15%"
    when 7
      @width = "13%"
    when 8
      @width = "11%"
    end
  end
end
