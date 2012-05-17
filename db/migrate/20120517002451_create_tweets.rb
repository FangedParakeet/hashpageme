class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
