module HpageHelper
  
  def gather_hashtags(category)
    hashtags = Hashtag.find_all_by_category_id(category.id)
    tags = []
    hashtags.each do |hashtag|
      tags << hashtag.tag
    end
    return tags
  end
  
  def create_category(category_name, hash)
    if !category_name.empty? # change to nil?
      category = Category.new
      category.header = category_name
      category.user_id = session[:user_id]
      category.save
      if !hash.empty?
        if hash.include?(",")
          hash.split(", ").each do |tag|
            hashtag = Hashtag.new
            hashtag.tag = tag
            hashtag.category_id = Category.find_by_header_and_user_id(category_name, session[:user_id]).id
            hashtag.user_id = session[:user_id]
            hashtag.save 
          end
        else
          hashtag = Hashtag.new
          hashtag.tag = hash
          hashtag.category_id = category.id
          hashtag.user_id = session[:user_id]
          hashtag.save 
        end
      end
    end
  end
  
  def update_local_tweets(user)
    page = ((user.tweets.count)/100)+1
    all_tweets = Twitter::FetchesTweets.fetch(user.handle, page)
    all_tweets.each do |tweet|
      if user.tweets.find_by_text(tweet["text"].sub(/&amp;/, '&'))
      else
        t = Tweet.new
        t.text = tweet["text"].sub(/&amp;/, '&')
        t.user_id = user.id
        t.save
      end
    end
    hashes = user.hashtags
    local_tweets = user.tweets
    local_tweets.each do |tweet|
      hashes.each do |hash|
        if hash.tag
          if tweet.text.downcase.include?(hash.tag.downcase)
            tweet.category_id = hash.category_id
            tweet.save
          end
        end
      end
    end
  end
    
end
