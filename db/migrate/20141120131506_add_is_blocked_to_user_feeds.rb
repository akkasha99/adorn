class AddIsBlockedToUserFeeds < ActiveRecord::Migration
  def change
    add_column :user_feeds, :is_active, :boolean , :default => true
  end
end
