class HpageController < ApplicationController
  
  include HpageHelper
  
  before_filter :require_login, :only => [:new, :create]

  def new
    categories = current_user.categories
    if !categories.empty?
      @cat1 = categories[0].header
      @cat2 = categories[1].header
      @cat3 = categories[2].header
      @tags1 = gather_hashtags(categories[0])
      @tags2 = gather_hashtags(categories[1])
      @tags3 = gather_hashtags(categories[2])
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