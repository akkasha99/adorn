class AddBlogTitleToUserFeed < ActiveRecord::Migration
  def change
    add_column :user_feeds, :feed_title, :string
  end
end
