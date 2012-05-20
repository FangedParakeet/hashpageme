require 'open-uri'
require 'json'

class Twitter::FetchesTweets
  
  def self.fetch(name, page)
    result = []
    tweets = JSON.parse(open("http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{name}&count=100&page=#{page}&include_rts=1&trim_user=true&include_entities=false&callback=?").read)  
    begin 
      result << tweets
      page += 1
      tweets = JSON.parse(open("http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{name}&count=100&page=#{page}&include_rts=1&trim_user=true&include_entities=false&callback=?").read)  
    end while !tweets.empty?
    result.flatten!
    return result
  end
  
end