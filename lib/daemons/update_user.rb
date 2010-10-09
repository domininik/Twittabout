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
  sleep 24
end