module CandidatesHelper
  def format_links(text)
    #regex = Regexp.new '((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)'
    #text.gsub!( regex, '<a href="\1">\1</a>' )
    text
  end
end
