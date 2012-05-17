class Tweet < ActiveRecord::Base
  attr_accessible :category_id, :text, :user_id
  
  belongs_to :user
  belongs_to :category
end
