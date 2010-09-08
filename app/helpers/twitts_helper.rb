module TwittsHelper
  def source(twitt)
    if (s = twitt.source) == 'web'
      "<a href='http://twitter.com'>Twitter.com</a>"
    else
      s
    end
  end
end
