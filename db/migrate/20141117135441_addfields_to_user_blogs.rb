class AddfieldsToUserBlogs < ActiveRecord::Migration
  def change
    add_column :user_blogs, :title, :string
    add_column :user_blogs, :content, :text, :limit => 1073741823
    add_column :user_blogs, :identifier, :string
    add_column :user_blogs, :web_link, :string
  end
end
