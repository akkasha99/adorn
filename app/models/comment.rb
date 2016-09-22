class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_item
  belongs_to :user_blog
  belongs_to :user_outfit
end
