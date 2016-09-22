class ChangeFeedIsActiveType < ActiveRecord::Migration
  def up
    # change_column :user_feeds, :is_active, :integer, :default => 2    ##for mysql
    change_column :user_feeds, :is_active, USING CAST(is_active AS integer)
    change_column :user_feeds, :is_active, :default => 2
  end

  def down
    change_column :user_feeds, :is_active, :boolean
  end
end
