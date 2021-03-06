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
  
  def total_tweets
    total ||= Setting.find_by_name('total_tweets')
    size = total.value.to_i if total
      if size
      last = size.to_s[-1,1]
      suffix = case last
      when '0','1','5','6','7','8','9'
        " tweetów napisanych"
      when '2','3','4'
        " tweety napisane"
      else
      end
      return size.to_s + suffix
    else
      "0 tweetów napisanych"
    end
  end
  
  def total_users
    total ||= Setting.find_by_name('total_users')
    total ? total.value.to_i : 0
  end
end
