class HpageController < ApplicationController
  
  include HpageHelper
  
  before_filter :require_login, :only => [:new, :create]

  def new
    categories = current_user.categories
    if !categories.empty?
      @cat1 = categories[0].header
      @cat2 = categories[1].header
      @cat3 = categories[2].header
      hashtags1 = Hashtag.find_all_by_category_id(categories[0].id)
      @tags1 = []
      hashtags1.each do |hashtag|
        @tags1 << hashtag.tag
      end
      hashtags2 = Hashtag.find_all_by_category_id(categories[1].id)
      @tags2 = []
      hashtags2.each do |hashtag|
        @tags2 << hashtag.tag
      end
      hashtags3 = Hashtag.find_all_by_category_id(categories[2].id)
      @tags3 = []
      hashtags3.each do |hashtag|
        @tags3 << hashtag.tag
      end
    else
      @cat1 = nil
      @cat2 = nil
      @cat3 = nil
      @tags1 = []
      @tags2 = []
      @tags3 = []
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
    3.times { |i| create_category(params["category#{i+1}"], params["hash#{i+1}"]) }
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
      page = ((@user.tweets.count)/100)+1
      all_tweets = Twitter::FetchesTweets.fetch(params[:id], page)
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