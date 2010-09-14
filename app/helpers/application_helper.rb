# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def clear
    "<div class=\"clear\"></div>"
  end
  
  def links_format(text)
    if text[0] == 64
      name = text.split.first.gsub('@','')
      user = TwitterUser.find_by_screen_name(name)
      text = text.gsub(/^@[^ ]*/, "<a href='/uzytkownicy/#{user.id}'>@#{name}</a>") if user
    end
    regex = Regexp.new 'http:\/\/[^ ]*'
    text = text.gsub(regex, '<a href="\0">\0</a>')
    return text
  end
end
