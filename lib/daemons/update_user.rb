#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment.rb"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while $running do
  TwitterUser.first(:order => "RAND()").update_data
  total = Setting.find_by_name('total_tweets')
  new_value = Twitt.all.size
  total.update_attribute(:value, new_value) if total
  sleep 48
end