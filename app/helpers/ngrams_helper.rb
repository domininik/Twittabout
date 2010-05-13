module NgramsHelper
  def format(text)
    text = text.gsub(';', "<br />")
  end
end
