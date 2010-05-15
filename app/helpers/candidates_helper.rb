module CandidatesHelper
  def format_links(text)
    #regex = Regexp.new '((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)'
    regex = Regexp.new 'http:\/\/[^ ]*'
    text.gsub!(regex, '<a href="\0">link</a>')
    text
  end
end
