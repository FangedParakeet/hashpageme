class Hashtag < ActiveRecord::Base
  attr_accessible :category_id, :tag, :user_id
  
  belongs_to :user
  belongs_to :category
  
end
