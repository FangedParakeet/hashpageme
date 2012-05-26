class HpageController < ApplicationController
  
  include HpageHelper
  
  before_filter :require_login, :only => [:new, :create]

  def new
    categories = current_user.categories
    if !categories.empty?
      if categories[0]
        @cat1 = categories[0].header
        @tags1 = gather_hashtags(categories[0])
      else
        @cat1 = nil
        @tags1 = []
      end
      if categories[1]
        @cat2 = categories[1].header
        @tags2 = gather_hashtags(categories[1])
      else
        @cat2 = nil
        @tags2 = []
      end
      if categories[2]
        @cat3 = categories[2].header
        @tags3 = gather_hashtags(categories[2])
      else
        @cat3 = nil
        @tags3 = []
      end    
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
    current_user.bio = params[:bio]
    current_user.save
    3.times { |i| create_category(params["category#{i+1}"], params["hash#{i+1}"]) }
    redirect_to profile_url("#{User.find_by_id(session[:user_id]).handle}")
  end 
  
  def index
  end

  def show
    @user = User.find_by_handle(params[:id].downcase)
    if @user.nil?
      flash[:no_page] = "Sorry--#{params[:id]} doesn't have a HashPage! Tell them to get one!"
      redirect_to root_url
    else
      update_local_tweets(@user)
      @categories = @user.categories
      @tweets = @user.tweets
    end
  end

end