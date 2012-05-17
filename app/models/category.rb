class Category < ActiveRecord::Base
  attr_accessible :header, :user_id
  
  belongs_to :user
  
  has_many :hashtags
  has_many :tweets
end
