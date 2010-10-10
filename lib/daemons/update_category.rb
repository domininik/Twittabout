#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment.rb"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  tweets = Twitt.all(:order => "originally_created DESC", :limit => 3000)
  tweets.each { |tweet| tweet.check_category }
  sleep 3600
end