# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def clear
    "<div class=\"clear\"></div>"
  end
  
  def links_format(text)
    if text[0] == 64
      name = text.split.first.gsub('@','')
      user = TwitterUser.find_by_screen_name(name)
      text = text.gsub(/^@[^ ]*/, "<a href='#{twitter_user_path(user)}'>@#{name}</a>") if user
    end
    regex = Regexp.new 'http:\/\/[^ ]*'
    text = text.gsub(regex, '<a href="\0">\0</a>')
    return text
  end
  
  def twitt_size
    size = Twitt.all.size
    last = size.to_s[-1,1]
    suffix = case last
    when '0','1','5','6','7','8','9'
      " twittów napisanych"
    when '2','3','4'
      " twitty napisane"
    else
    end
    return size.to_s + suffix
  end
end
