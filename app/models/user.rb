class User < ActiveRecord::Base
  attr_accessible :bio, :handle, :name, :photo, :provider, :uid
  
  has_many :categories
  has_many :hashtags
  has_many :tweets
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"] 
      user.photo = auth["info"]["image"]
      user.handle = auth["info"]["nickname"]     
    end
  end
  
end
