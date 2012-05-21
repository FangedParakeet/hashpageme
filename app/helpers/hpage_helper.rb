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
    category = Category.new
    category.header = category_name
    category.user_id = session[:user_id]
    category.save
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
