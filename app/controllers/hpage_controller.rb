require 'open-uri'
require 'json'

class HpageController < ApplicationController
  before_filter :require_login, :only => [:new, :create]
  
  def fetch_tweets(name, page)
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

  def new
    categories = current_user.categories
    @cat1 = categories[0]
    @cat2 = categories[1]
    @cat3 = categories[2]
    hashtags1 = Hashtag.find_all_by_category_id(@cat1.id)
    @tags1 = []
    hashtags1.each do |hashtag|
      @tags1 << hashtag.tag
    end
    hashtags2 = Hashtag.find_all_by_category_id(@cat2.id)
    @tags2 = []
    hashtags2.each do |hashtag|
      @tags2 << hashtag.tag
    end
    hashtags3 = Hashtag.find_all_by_category_id(@cat3.id)
    @tags3 = []
    hashtags3.each do |hashtag|
      @tags3 << hashtag.tag
    end
    @bio = current_user.bio
  end
  
  def create
    current_user.categories.each do |cat|
      cat.destroy
    end
    current_user.hashtags.each do |tag|
      tag.destroy
    end
    User.find_by_id(session[:user_id]).bio = params[:bio]
    c1 = Category.new
    c1.header = params[:category1]
    c1.user_id = session[:user_id]
    c1.save
    if params[:hash1].include?(",")
      params[:hash1].split(", ").each do |tag|
        h1 = Hashtag.new
        h1.tag = tag
        h1.category_id = Category.find_by_header_and_user_id(params[:category1], session[:user_id]).id
        h1.user_id = session[:user_id]
        h1.save 
      end
    else
    h1 = Hashtag.new
    h1.tag = params[:hash1]
    h1.category_id = c1.id
    h1.user_id = session[:user_id]
    h1.save 
    end
    
    c2 = Category.new
    c2.header = params[:category2]
    c2.user_id = session[:user_id]
    c2.save
    if params[:hash2].include?(",")
      params[:hash2].split(", ").each do |tag|
        h2 = Hashtag.new
        h2.tag = tag
        h2.category_id = Category.find_by_header_and_user_id(params[:category2], session[:user_id]).id
        h2.user_id = session[:user_id]
        h2.save 
      end
    else
    h2 = Hashtag.new
    h2.tag = params[:hash2]
    h2.category_id = c2.id
    h2.user_id = session[:user_id]
    h2.save 
    end
    
    c3 = Category.new
    c3.header = params[:category3]
    c3.user_id = session[:user_id]
    c3.save
    if params[:hash3].include?(",")
      params[:hash3].split(", ").each do |tag|
        h3 = Hashtag.new
        h3.tag = tag
        h3.category_id = Category.find_by_header_and_user_id(params[:category3], session[:user_id]).id
        h3.user_id = session[:user_id]
        h3.save 
      end
    else
    h3 = Hashtag.new
    h3.tag = params[:hash3]
    h3.category_id = c3.id
    h3.user_id = session[:user_id]
    h3.save 
    end
  
  redirect_to "http://localhost:3000/#{User.find_by_id(session[:user_id]).handle}"
  end
      
      
      
  
  def index
  end
  

  
  def show
    @user = User.find_by_handle(params[:id])
    if @user.nil?
      flash[:no_page] = "Sorry--#{params[:id]} doesn't have a HashPage! Tell them to get one!"
      redirect_to root_url
    else
      if @user.tweets
        page = ((@user.tweets.count)/100)+1
      else
        page = 1
      end
      all_tweets = fetch_tweets(params[:id], page)
      @categories = @user.categories
      hashes = @user.hashtags
      all_tweets.each do |tweet|
        if @user.tweets.find_by_text(tweet["text"].sub(/&amp;/, '&'))
        else
        t = Tweet.new
        t.text = tweet["text"].sub(/&amp;/, '&')
        t.user_id = @user.id
        t.save
      end
      end
      @local_tweets = @user.tweets
      @local_tweets.each do |tweet|
        hashes.each do |hash|
          if hash.tag
            if tweet.text.include?(hash.tag)
            tweet.category_id = hash.category_id
            end
          end
        end
      end
    end
  end

end