# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def clear
    "<div class=\"clear\"></div>"
  end
  
  def links_format(text)
    regex = Regexp.new 'http:\/\/[^ ]*'
    text.gsub(regex, '<a href="\0">\0</a>')
  end
end
