class AddIsBlockedToUserFeeds < ActiveRecord::Migration
  def change
    add_column :user_feeds, :is_active, :integer , :default => 2
  end
end
